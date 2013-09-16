/* Here's a script that outputs the exact time of every gif from my collection
   dtrace -Z -s 7.d
****/

#pragma D option quiet

BEGIN
{
  printf("Tracing your gifs....\n");
}

node*:::http-server-request
{
  /* thread-local variable: */
  self->ts = timestamp;
}

gifserver*:::respond-gif
{
  self->gif = copyinstr(arg0);
}

node*:::http-server-response
/self->gif != 0/
{
  this->time = timestamp - self->ts;
  self->ts = 0;

  printf("%s spent %d nsecs serving %s\n", execname, this->time, self->gif);

  @avg_time[strjoin("Average time for ", self->gif)] = avg(this->time);
}
