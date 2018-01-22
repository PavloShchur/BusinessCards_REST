public class ContactTestUtilities {   
    
    public static void sleep(integer milliseconds)  {
            Long timeDiff = 0;
            DateTime firstTime = System.now();
            do {
                timeDiff = System.now().getTime() - firstTime.getTime();
            }
            while(timeDiff <= milliseconds);      
    }
    
}