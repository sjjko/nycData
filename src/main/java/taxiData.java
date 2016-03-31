import au.com.bytecode.opencsv.CSVWriter;
import com.google.gson.annotations.SerializedName;

import com.socrata.model.Location;
import org.codehaus.jackson.annotate.JsonCreator;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.annotate.JsonProperty;


/**
 * Created by kos on 29.03.16.
 */
public class taxiData implements genericDataInterface {


    //taxi data

    @SerializedName("pickup_datetime")
    String pickup_datetime;
    @SerializedName("pickup_latitude")
    String pickup_latitude;
    @SerializedName("pickup_longitude")
    String pickup_longitude;
    @SerializedName("dropoff_datetime")
    String dropoff_datetime;
    @SerializedName("dropoff_latitude")
    String dropoff_latitude;
    @SerializedName("dropoff_longitude")
    String dropoff_longitude;
    @SerializedName("fare_amount")
    String fare_amount;
    @SerializedName("passenger_count")
    String passenger_count;
    @SerializedName("payment_type")
    String payment_type;
    @SerializedName("tip_amount")
    String tip_amount;
    @SerializedName("trip_distance")
    String trip_distance;
    @SerializedName("extra")
    String extra;
    @SerializedName("rate_code")
    String rate_code;
    @SerializedName("store_and_fwd_flag")
    String store_and_fwd_flag;
    @SerializedName("tolls_amount")
    String tolls_amount;
    @SerializedName("total_amount")
    String total_amount;
    @SerializedName("vendor_id")
    String vendor_id;
    @SerializedName("mta_tax")
    String mta_tax;

    public taxiData(){}

    @JsonCreator
    public taxiData(@JsonProperty("pickup_datetime") String pickup_datetime,
                     @JsonProperty("pickup_latitude") String pickup_latitude,
                     @JsonProperty("pickup_longitude") String pickup_longitude,
                    @JsonProperty("dropoff_datetime") String dropoff_datetime,
                    @JsonProperty("dropoff_latitude") String dropoff_latitude,
                    @JsonProperty("dropoff_longitude") String dropoff_longitude,
                    @JsonProperty("fare_amount") String fare_amount,
                    @JsonProperty("passenger_count") String passenger_count,
                    @JsonProperty("payment_type") String payment_type,
                    @JsonProperty("tip_amount") String tip_amount,
                    @JsonProperty("extra") String extra,
                    @JsonProperty("mta_tax") String mta_tax,
                    @JsonProperty("rate_code") String rate_code,
                    @JsonProperty("store_and_fwd_flag") String store_and_fwd_flag,
                    @JsonProperty("tolls_amount") String tolls_amount,
                    @JsonProperty("total_amount") String vendor_id,
                    @JsonProperty("vendor_id") String total_amount,
                    @JsonProperty("trip_distance") String trip_distance)


    {
        this.pickup_datetime = pickup_datetime;
        this.pickup_latitude = pickup_latitude;
        this.pickup_longitude = pickup_longitude;
        this.dropoff_datetime = dropoff_datetime;
        this.dropoff_longitude = dropoff_longitude;
        this.dropoff_latitude = dropoff_latitude;
        this.fare_amount = fare_amount;
        this.passenger_count = passenger_count;
        this.payment_type = payment_type;
        this.tip_amount = tip_amount;
        this.trip_distance = trip_distance;
        this.extra = extra;
        this.rate_code = rate_code;
        this.store_and_fwd_flag = store_and_fwd_flag;
        this.tolls_amount = tolls_amount;
        this.vendor_id = vendor_id;
        this.total_amount = total_amount;
    }

    //@Override
    public void writeCSVHeader(CSVWriter writer)
    {
        String[] entries = {"pickup_date","pickup_time","pickup_latitude","pickup_longitude","dropoff_date","dropoff_time","dropoff_latitude",
                "dropoff_longitude","fare_amount","passenger_count","tip_amount","trip_distance"};
        writer.writeNext(entries);

    }

    //@Override
     String get_date(String datetime)
    {
        String date=datetime.split("T")[0];
        String month=date.split("-")[1];
        return month;
    }
    //@Override
     double get_time(String datetime)
    {
        String time=datetime.split("T")[1];
        double hour=Double.parseDouble(time.split(":")[0]);
        double minute=Double.parseDouble(time.split(":")[1]);
        double seconds=Double.parseDouble(time.split(":")[2]);
        double thisval=hour*3600+minute*60+seconds;
        return thisval;
    }

    //@Override
    public void writeCSV(CSVWriter writer)
    {
        String pickup_date=get_date(pickup_datetime);
        double pickup_time=get_time(pickup_datetime);
        String dropoff_date=get_date(dropoff_datetime);
        double dropoff_time=get_time(dropoff_datetime);

        String[] entries = {pickup_date,Double.toString(pickup_time),pickup_latitude,pickup_longitude,dropoff_date,Double.toString(dropoff_time),dropoff_latitude,dropoff_longitude,fare_amount,passenger_count,tip_amount,trip_distance};
        writer.writeNext(entries);

    }

    public String getExtra() {
        return extra;
    }

    public String getRate_code() {
        return rate_code;
    }

    public void setTolls_amount(String tolls_amount) {
        this.tolls_amount = tolls_amount;
    }

    public String getTolls_amount() {
        return tolls_amount;
    }

    public String getVendor_id() {
        return vendor_id;
    }

    public String getDropoff_latitude() {
        return dropoff_latitude;
    }

    public String getDropoff_datetime() {
        return dropoff_datetime;
    }

    public String getDropoff_longitude() {
        return dropoff_longitude;
    }

    public String getFare_amount() {
        return fare_amount;
    }

    public String getPassenger_count() {
        return passenger_count;
    }

    public String getPayment_type() {
        return payment_type;
    }

    public String getTrip_distance() {
        return trip_distance;
    }

    public String getTip_amount() {
        return tip_amount;
    }

    public String getpickup_datetime()
    {
        return pickup_datetime;
    }
    public String getpickup_latitude()
    {
        return pickup_latitude;
    }
    public String getpickup_longitude()
    {
        return pickup_longitude;
    }


}
