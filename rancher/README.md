Win: ``` docker logs <container_id> 2>&1 | Select-String "Bootstrap Password:"```
Other: ```docker logs <container_id> 2>&1 | grep "Bootstrap Password:"```
