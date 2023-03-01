public class Breaker
{
    public bool Stop { get; private set; } = false;

    private int _delayTime;

    public Breaker(int delayTime)
    {
        _delayTime = delayTime;
    }

    public void SetDelay()
    {
        Thread.Sleep(_delayTime * 1000);
        Stop = true;
    }
}