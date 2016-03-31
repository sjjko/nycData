import au.com.bytecode.opencsv.CSVReader;
import au.com.bytecode.opencsv.CSVWriter;
import com.google.gson.reflect.TypeToken;
import com.socrata.api.HttpLowLevel;
import com.socrata.api.Soda2Consumer;
import com.socrata.builders.SoqlQueryBuilder;
import com.socrata.exceptions.LongRunningQueryException;
import com.socrata.exceptions.SodaError;
import com.socrata.model.importer.Column;
import com.socrata.model.importer.Dataset;
import com.socrata.model.soql.OrderByClause;
import com.socrata.model.soql.SoqlClauses;
import com.socrata.model.soql.SoqlQuery;
import com.socrata.model.soql.SortOrder;
import com.sun.jersey.api.client.ClientResponse;
import com.socrata.api.SodaDdl;
import com.sun.jersey.api.client.GenericType;
import org.apache.avro.generic.GenericArray;

import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by kos on 16.
 * class to read nyc opendata - outputs to csv and sql for later reuse
 */
public class nycSoda {

//    String urli = "https://data.cityofnewyork.us/view/ba8s-jw6u";
//    HttpLowLevel httplowlevel = new HttpLowLevel(urli);
//Soda2Consumer soda2consumer = new Soda2Consumer();

    //https://data.cityofnewyork.us/view/ba8s-jw6u.json?$limit=100&offset=1000&


    private ArrayList<Column> columns;
    static final int MAXDATASIZE=25000;
    static final String nyBaseUrl="https://data.cityofnewyork.us/";
    static final String taxistring="2yzn-sicd";
    static final String crashstring="h9gi-nx95";
    static final int samplingOffset=100;
    static final int samplesize=10;
    static String stringidentifier;
    List<taxiData> globalDataList;

    public void nycSoda(){}

    private static ClientResponse getResponse(String identifierString,Soda2Consumer inputConsumer, SoqlQuery query)
    {
        ClientResponse responsefullquery=null;
        try {
            responsefullquery = inputConsumer.query(identifierString, HttpLowLevel.JSON_TYPE,query);
        } catch (LongRunningQueryException e) {
            e.printStackTrace();
        } catch (SodaError sodaError) {
            sodaError.printStackTrace();
        }
        return responsefullquery;

    }

    private static SoqlQuery buildQuery()
    {
        SoqlQuery rsoqlquery = new SoqlQueryBuilder()
                //.setWhereClause("")
                .setLimit(samplesize)
                .setOffset(samplingOffset)
                //.addOrderByPhrase(new OrderByClause(SortOrder.Descending, "pickup_datetime"))
                .build();

        return rsoqlquery;

    }

    private void selectCase(String casename)
    {
        if(casename=="taxi")
        {
            stringidentifier=taxistring;
        }
        else if(casename=="crash")
        {
            stringidentifier=crashstring;
        }
        else
        {
            System.out.println("give valid casename taxi or crash!");
            //throw new NoSuchFieldException;
        }

    }

    private void generateTaxiData(Soda2Consumer inputconsumer)
    {
        SoqlQuery soqlquery=buildQuery();
        ClientResponse responsefullquery = getResponse(stringidentifier,inputconsumer,soqlquery);
        final List<taxiData> resultsquerylist = responsefullquery.getEntity(new GenericType<List<taxiData>>() {});
        int offset=0;
        int oldlength=0;
        int newlength=10;
        while(oldlength<newlength && responsefullquery.getClientResponseStatus().toString()=="OK" && resultsquerylist.size()<=MAXDATASIZE) {
            oldlength=newlength;
            offset = offset + samplingOffset;
            System.out.println("offset is " + offset);
            soqlquery = new SoqlQueryBuilder()
                    .setLimit(samplesize)
                    .setOffset(offset)
                    .build();

            responsefullquery = getResponse(stringidentifier,inputconsumer,soqlquery);
            resultsquerylist.addAll(responsefullquery.getEntity(new GenericType<List<taxiData>>() {}));

            newlength=resultsquerylist.size();
            System.out.println(resultsquerylist.size());
        }

        globalDataList=resultsquerylist;
        System.out.println("finished reading data from nyc database");

        System.out.println("write data into csv");
        CSVWriter writer = null;
        try {
            writer = new CSVWriter(new FileWriter("taxiSoda.csv"), ',');
        } catch (IOException e) {
            e.printStackTrace();
        }

        resultsquerylist.get(0).writeCSVHeader(writer);
        for (taxiData mydata : resultsquerylist) {
            mydata.writeCSV(writer);
        }
        System.out.println("csv file written - close");
        try {
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private void generateCrashData(Soda2Consumer inputconsumer)
    {
        SoqlQuery soqlquery=buildQuery();
        ClientResponse responsefullquery = getResponse(stringidentifier,inputconsumer,soqlquery);
        final List<crashData> resultsquerylist = responsefullquery.getEntity(new GenericType<List<crashData>>() {});
        int offset=0;
        String status="OK";
        int oldlength=0;
        int newlength=10;
        while(oldlength<newlength && status=="OK" && resultsquerylist.size()<=MAXDATASIZE) {
            oldlength=newlength;
            offset = offset + samplingOffset;
            System.out.println("offset is " + offset);
            soqlquery = new SoqlQueryBuilder()
                    .setLimit(samplesize)
                    .setOffset(offset)
                    .build();

            responsefullquery = getResponse(stringidentifier,inputconsumer,soqlquery);
            resultsquerylist.addAll(responsefullquery.getEntity(new GenericType<List<crashData>>() {}));

            System.out.println(resultsquerylist.size());
            newlength=resultsquerylist.size();
            status=responsefullquery.getClientResponseStatus().toString();
        }

        System.out.println("finished reading data from nyc database");

        System.out.println("write data into csv");
        CSVWriter writer = null;
        try {
            writer = new CSVWriter(new FileWriter("crash.csv"), ',');
        } catch (IOException e) {
            e.printStackTrace();
        }

        resultsquerylist.get(0).writeCSVHeader(writer);
        for (crashData mydata : resultsquerylist) {
            mydata.writeCSV(writer);
        }
        System.out.println("csv file written - close");
        try {
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }




    public static void main(String[]args) {


            nycSoda ns = new nycSoda();
            String caseName="taxi";
            ns.selectCase(caseName);
            Soda2Consumer consumer = Soda2Consumer.newConsumer(nyBaseUrl); //2yzn-sicd.json

            if(caseName=="taxi") {
                ns.generateTaxiData(consumer);
            }
            else if(caseName=="crash")
            {
                ns.generateCrashData(consumer);
            }
        else{
                System.out.println("error");
            }

        System.out.println("finished nycSoda");


    }

}
