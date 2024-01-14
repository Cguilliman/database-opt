### Removing the last column in the slave table

![remove last column](https://github.com/Cguilliman/database-opt/blob/master/replication/img/SCR-20240114-oss.png)

Master data before and after remoing to compare it with the slave source.

*yellow - before removing; blue - after removing

![master data source](https://github.com/Cguilliman/database-opt/blob/master/replication/img/SCR-20240114-oua.png)

As we can see after removing slave stil able to replicate data.

*yellow - before removing; blue - after removing

![slave data source](https://github.com/Cguilliman/database-opt/blob/master/replication/img/SCR-20240114-ovu.png)

---
### Removing the column in the middle of the table

![remove column in the middle](https://github.com/Cguilliman/database-opt/blob/master/replication/img/SCR-20240114-ox5.png)

Slave replication has been broken here!

![replication error after removing](https://github.com/Cguilliman/database-opt/blob/master/replication/img/SCR-20240114-oy3.png)

