-- docker exec -it ksqldb-cli ksql http://ksqldb-server:8088

DROP STREAM rawTempReadings DELETE TOPIC;

-- 1. Create raw readings stream
CREATE STREAM rawTempReadings (sensorID VARCHAR KEY, temp DOUBLE)
  WITH (kafka_topic='RawTempReadings', key_format='KAFKA', value_format='KAFKA', partitions=1);

-- 2. Create converted readings table
CREATE STREAM convertedTempReadings (sensorID VARCHAR KEY, temp DOUBLE)
  WITH (kafka_topic='ConvertedTempReadings', key_format='KAFKA', value_format='KAFKA', partitions=1);

-- 3. Create streaming query for filtered results
SELECT *
FROM convertedTempReadings EMIT CHANGES;

-- 4. Split new window
-- docker exec -it ksqldb-cli ksql http://ksqldb-server:8088

-- 5. Insert filterable results
INSERT INTO rawTempReadings (sensorID, temp) VALUES ('abc123', -40);
INSERT INTO rawTempReadings (sensorID, temp) VALUES ('abc123', 32);
INSERT INTO rawTempReadings (sensorID, temp) VALUES ('abc123', 212);


