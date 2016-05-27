CREATE KEYSPACE test_time WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

CREATE TABLE test_time.sent_received(
 time_sent TEXT,
 time_received TEXT,
PRIMARY KEY (time_sent)
);

