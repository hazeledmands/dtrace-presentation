/* Here's a script that outputs the exact time of every request/response cycle
   as well as the time spent in GC.
   dtrace -s 5.d
****/

#pragma D option quiet

BEGIN
{
  printf("Tracing your nodes....\n")
}

node*:::http-server-request
{
  /* thread-local variable: */
  self->ts = timestamp;
}

node*:::http-server-response
{
  this->time = timestamp - self->ts;
  self->ts = 0;

  printf("%s spent %d nsecs building an http-server-response\n", execname, this->time);

  @avg_time[strjoin("Average time for ", execname)] = avg(this->time);
  @quant_time[strjoin("Quantized time distribution for ", execname)] = quantize(this->time);
}
