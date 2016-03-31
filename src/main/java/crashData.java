import au.com.bytecode.opencsv.CSVWriter;
import com.google.gson.annotations.SerializedName;
import org.codehaus.jackson.annotate.JsonCreator;
import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonProperty;


/**
 * Created by kos on 29.03.16.
 */
public class crashData  extends genericDataClass {


    // car crash json data

    @SerializedName("unique_key")
    String unique_key;
    @SerializedName("date")
    String date;
    @SerializedName("time")
    String time;
    @JsonIgnore
    //@SerializedName("borough")
    String borough;
    @SerializedName("latitude")
    String latitude;
    @SerializedName("longitude")
    String longitude;
    @SerializedName("number_of_persons_injured")
    String number_of_persons_injured;
    @SerializedName("number_of_persons_killed")
    String number_of_persons_killed;
    @SerializedName("number_of_pedestrians_injured")
    String number_of_pedestrians_injured;
    @SerializedName("number_of_pedestrians_killed")
    String number_of_pedestrians_killed;
    @SerializedName("number_of_cyclist_injured")
    String number_of_cyclist_injured;
    @SerializedName("number_of_cyclist_killed")
    String number_of_cyclist_killed;
    @SerializedName("number_of_motorist_injured")
    String number_of_motorist_injured;
    @SerializedName("number_of_motorist_killed")
    String number_of_motorist_killed;
    @SerializedName("contributing_factor_vehicle_1")
    String contributing_factor_vehicle_1;
    @SerializedName("contributing_factor_vehicle_2")
    String contributing_factor_vehicle_2;
    @SerializedName("contributing_factor_vehicle_3")
    String contributing_factor_vehicle_3;
    @SerializedName("vehicle_type_code1")
    String vehicle_type_code1;
    @SerializedName("vehicle_type_code2")
    String vehicle_type_code2;
    //@SerializedName("vehicle_type_code3")
    @JsonIgnore
    String vehicle_type_code3;
     @SerializedName("zip_code")
    String zip_code;
    @JsonIgnore
    String location;
    @JsonIgnore
    String on_street_name;
    @JsonIgnore
    String off_street_name;
    @JsonIgnore
    String cross_street_name;
    @JsonIgnore
    String vehicle_type_code_3;
    @JsonIgnore
    String vehicle_type_code_5;
    @JsonIgnore
    String contributing_factor_vehicle_5;
    @JsonIgnore
    String vehicle_type_code_4;
    @JsonIgnore
    String contributing_factor_vehicle_4;

    @JsonIgnore
    public String getContributing_factor_vehicle_4() {
        return contributing_factor_vehicle_4;
    }

    @JsonIgnore
    public void setContributing_factor_vehicle_4(String contributing_factor_vehicle_4) {
        this.contributing_factor_vehicle_4 = contributing_factor_vehicle_4;
    }


    @JsonIgnore
    public String getVehicle_type_code_4() {
        return vehicle_type_code_4;
    }
    @JsonIgnore
    public void setVehicle_type_code_4(String vehicle_type_code_4) {
        this.vehicle_type_code_4 = vehicle_type_code_4;
    }

    @JsonIgnore
    public String getContributing_factor_vehicle_5() {
        return contributing_factor_vehicle_5;
    }

    @JsonIgnore
    public void setContributing_factor_vehicle_5(String contributing_factor_vehicle_5) {
        this.contributing_factor_vehicle_5 = contributing_factor_vehicle_5;
    }

    @JsonIgnore
    public String getVehicle_type_code_5() {
        return vehicle_type_code_5;
    }

    @JsonIgnore
    public void setVehicle_type_code_5(String vehicle_type_code_5) {
        this.vehicle_type_code_5 = vehicle_type_code_5;
    }

    @JsonIgnore
    public String getVehicle_type_code_3() {
        return vehicle_type_code_3;
    }

    @JsonIgnore
    public void setVehicle_type_code_3(String vehicle_type_code_3) {
        this.vehicle_type_code_3 = vehicle_type_code_3;
    }

    public crashData(){};

    @JsonCreator
    public crashData(@JsonProperty("unique_key") String unique_key,
                     @JsonProperty("date") String date,
                     @JsonProperty("time") String time,
                     @JsonProperty("borough") String borough,
                     @JsonProperty("latitude") String latitude,
                     @JsonProperty("longitude") String longitude,
                     @JsonProperty("number_of_persons_injured") String number_of_persons_injured,
                     @JsonProperty("number_of_persons_killed") String number_of_persons_killed,
                     @JsonProperty("number_of_pedestrians_injured") String number_of_pedestrians_injured,
                     @JsonProperty("number_of_pedestrians_killed") String number_of_pedestrians_killed,
                     @JsonProperty("number_of_cyclist_injured") String number_of_cyclist_injured,
                     @JsonProperty("number_of_cyclist_killed") String number_of_cyclist_killed,
                     @JsonProperty("number_of_motorist_injured") String number_of_motorist_injured,
                     @JsonProperty("number_of_motorist_killed") String number_of_motorist_killed,
                     @JsonProperty("contributing_factor_vehicle_1") String contributing_factor_vehicle_1,
                     @JsonProperty("contributing_factor_vehicle_2") String contributing_factor_vehicle_2,
                     @JsonProperty("contributing_factor_vehicle_3") String contributing_factor_vehicle_3,
                     //@JsonProperty("vehicle_type_code3") String vehicle_type_code3,
                    @JsonProperty("vehicle_type_code2") String vehicle_type_code2,
                    @JsonProperty("vehicle_type_code1") String vehicle_type_code1,
                     @JsonProperty("zip_code") String zip_code
                   // @JsonProperty("location") String location

    )

    {
        this.unique_key = unique_key;
        this.date = date;
        this.time = time;
       // this.borough = borough;
        this.latitude = latitude;
        this.longitude = longitude;
        this.number_of_persons_injured = number_of_persons_injured;
        this.number_of_persons_killed = number_of_persons_killed;
        this.number_of_pedestrians_injured = number_of_pedestrians_injured;
        this.number_of_pedestrians_killed = number_of_pedestrians_killed;
        this.number_of_cyclist_injured = number_of_cyclist_injured;
        this.number_of_cyclist_killed = number_of_cyclist_killed;
        this.number_of_motorist_injured = number_of_motorist_injured;
        this.number_of_motorist_killed = number_of_motorist_killed;
        this.contributing_factor_vehicle_1 = contributing_factor_vehicle_1;
        this.contributing_factor_vehicle_2 = contributing_factor_vehicle_2;
        this.vehicle_type_code1 = vehicle_type_code1;
        this.vehicle_type_code2 = vehicle_type_code2;
        //this.vehicle_type_code3 = vehicle_type_code3;
        this.zip_code = zip_code;
      //  this.location = location;

    }

    @JsonIgnore
    public String getVehicle_type_code3() {
        return vehicle_type_code3;
    }

    @JsonIgnore
    public void setVehicle_type_code3(String vehicle_type_code3) {
        this.vehicle_type_code3 = vehicle_type_code3;
    }

    public String getVehicle_type_code2() {
        return vehicle_type_code2;
    }

    public String getVehicle_type_code1() {
        return vehicle_type_code1;
    }

    public String getZip_code() {
        return zip_code;
    }

    @JsonIgnore
    public void setCross_street_name(String cross_street_name) {
        this.cross_street_name = cross_street_name;
    }

    @JsonIgnore
    public String getCross_street_name() {
        return cross_street_name;
    }

    @JsonIgnore
    public String getOn_street_name() {
        return on_street_name;
    }
    @JsonIgnore
    public String getOn_street_name(String on_street_name) {
        return on_street_name;
    }

    @JsonIgnore
    public String getOff_street_name() {
        return off_street_name;
    }
    @JsonIgnore
    public String getOff_street_name(String on_street_name) {
        return off_street_name;
    }


    @JsonIgnore
    public String setLocation(String location) {
        return location;
    }

    @JsonProperty
    public String getLocation() {
        return location;
    }

    @Override
    public void writeCSVHeader(CSVWriter writer)
    {
        String[] entries = {"unique_key","date","time","latitude","longitude",
                "number_of_persons_injured","number_of_persons_killed",
                "number_of_pedestrians_killed","number_of_pedestrians_injured",
                "number_of_cyclist_injured","number_of_cyclist_killed",
                "number_of_motorist_injured","number_of_motorist_killed",
                "contributing_factor_vehicle_1"
                //,"contributing_factor_vehicle_2",
                //"vehicle_type_code1"
                };
        writer.writeNext(entries);

    }

     String get_month(String datetime)
    {
        String date=datetime.split("T")[0];
        String month=date.split("-")[1];
        return month;
    }
    String get_year(String datetime)
    {
        String date=datetime.split("T")[0];
        String year=date.split("-")[1];
        return year;
    }
    @Override
     double get_time(String datetime)
    {
        String time=datetime.split("T")[1];
        double hour=Double.parseDouble(time.split(":")[0]);
        double minute=Double.parseDouble(time.split(":")[1]);
        double seconds=Double.parseDouble(time.split(":")[2]);
        double thisval=hour*3600+minute*60+seconds;
        return thisval;
    }

    @Override
    public void writeCSV(CSVWriter writer)
    {


        String[] entries = {unique_key,date,time,latitude,longitude,
                number_of_persons_injured,number_of_persons_killed,
                number_of_pedestrians_killed,number_of_pedestrians_injured,
                number_of_cyclist_injured,number_of_cyclist_killed,
                number_of_motorist_injured,number_of_motorist_killed,
                contributing_factor_vehicle_1
                //,contributing_factor_vehicle_2,
                //vehicle_type_code1
        };
        writer.writeNext(entries);

    }

    public String getnumber_of_cyclist_killed() {
        return number_of_cyclist_killed;
    }

    public String getnumber_of_motorist_injured() {
        return number_of_motorist_injured;
    }

    public void setTolls_amount(String contributing_factor_vehicle_1) {
        this.contributing_factor_vehicle_1 = contributing_factor_vehicle_1;
    }

    public String getcontributing_factor_vehicle_1() {
        return contributing_factor_vehicle_1;
    }

    public String getcontributing_factor_vehicle_2() {
        return contributing_factor_vehicle_2;
    }

    public String getlongitude() {
        return longitude;
    }

    @JsonIgnore
    public String getborough() {
        return borough;
    }

    public String getlatitude() {
        return latitude;
    }

    public String getnumber_of_persons_injured() {
        return number_of_persons_injured;
    }

    public String getnumber_of_persons_killed() {
        return number_of_persons_killed;
    }

    public String getnumber_of_pedestrians_injured() {
        return number_of_pedestrians_injured;
    }

    public String getnumber_of_cyclist_injured() {
        return number_of_cyclist_injured;
    }

    public String getnumber_of_pedestrians_killed() {
        return number_of_pedestrians_killed;
    }

    public String getunique_key()
    {
        return unique_key;
    }
    public String getdate()
    {
        return date;
    }
    public String gettime()
    {
        return time;
    }


}
