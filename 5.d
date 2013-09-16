/* Here's a script that outputs the exact time of every request/response cycle
   as well as the time spent in GC. */

#pragma D option quiet

BEGIN
{
  printf("%-22s %-20s %-8s %-16s %-16s %-16s\n",
      "DIRECTION", "URL", "METHOD", "REMOTEADDRESS", "REMOTEPORT", "FD");
}

node*:::http-server-request
{
}

node*:::http-server-response
{
  printf("%-22s %-20s %-8s %-16s %-16d %-16d\n",
      probename, " ", " ", args[0]->remoteAddress, args[1]->remotePort, args[1]->fd);
}
