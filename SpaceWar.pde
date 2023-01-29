/*

By:
Alan Tong

REQUIREMENTS of Animated Figure:

Use Ctrl + F to find the location of the tags

Tags:           | Requirement:
RQLoop          | While loop for drawing shapes (Updates all ships which inturn draws shapes)
RQKeystrokes    | Mutliple keys to spawn in new ships. Spawn in a ship for player 1 with 1-4, and spawn in a ship for player 2 with 7-0.
                | Spawn in allies with '[' and enemies with ']' Clear the screen with '\' Spawn in specific allied ships with 'r', 't', 'y', and 'u'
                | Spawn in specific enemy ships with 'g', 'h', 'j', and 'k'
RQArrowKeys     | Arrow keys control player 2
RQMouseMovement | Mouse movement controls player 1

*/

//Main
ArrayList<Collider> colliders;
ArrayList<Ship> ships;
ArrayList<Projectile> projectiles;

ArrayList<IUpdatable> updatables;

public boolean playerShipExists;
public boolean player2ShipExists;

OnKeyChangedEvent OnKeyReleased = new OnKeyChangedEvent();
OnKeyChangedEvent OnKeyPressed = new OnKeyChangedEvent();
OnMouseChangedEvent OnMousePressed = new OnMouseChangedEvent();

public class OnKeyChangedEvent extends Event<OnKeyChangedArgs> 
{
  
}

public class OnKeyChangedArgs extends EventArgs
{
  private char affectedKey;
  public OnKeyChangedArgs(char affectedKey)
  {
    this.affectedKey = affectedKey;
  }
}

public class OnMouseChangedEvent extends Event<OnMouseChangedArgs> 
{
  
}

public class OnMouseChangedArgs extends EventArgs
{
  private int affectedButton;
  public OnMouseChangedArgs(int affectedButton)
  {
    this.affectedButton = affectedButton;
  }
}


public void keyReleased() 
{
  OnKeyReleased.Invoke(new OnKeyChangedArgs(key));
}

public void keyPressed()
{
  OnKeyPressed.Invoke(new OnKeyChangedArgs(key));
}

public void mousePressed()
{
  OnMousePressed.Invoke(new OnMouseChangedArgs(mouseButton));
}

public final int PLAYER_TEAM = 0;
public final int ENEMY_TEAM = 1;
public final color[][] TEAM_COLORS = new color[][] 
{
  new color[] { color(255, 255, 255), color(0, 255, 255), color(200, 200, 200), color(150, 150, 150) },
  new color[] { color(255, 255, 255), color(255, 0, 0), color(200, 200, 200), color(150, 150, 150) }
};

//RQKeystrokes
public class SpawnPlayerShipKeyListener extends EventListener<OnKeyChangedArgs>
{
  public void Recieve(OnKeyChangedArgs args)
  {
    if (playerShipExists)
      return;
    
    if (args.affectedKey == '1') 
    {
      playerShipExists = true;
      new Fighter(new ManualControl(), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '2')
    {
      playerShipExists = true;
      new CQC(new ManualControl(), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '3')
    {
      playerShipExists = true;
      new Frigate(new ManualControl(), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '4')
    {
      playerShipExists = true;
      new Capital(new ManualControl(), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
  }
}

public class SpawnPlayer2ShipKeyListener extends EventListener<OnKeyChangedArgs>
{
  public void Recieve(OnKeyChangedArgs args)
  {
    if (player2ShipExists)
      return;
      
    if (args.affectedKey == '0')
    {
      player2ShipExists = true;
      new Fighter(new Player2ManualControl(250, 0.25), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '9')
    {
      player2ShipExists = true;
      new CQC(new Player2ManualControl(200, 0.5), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '8')
    {
      player2ShipExists = true;
      new Frigate(new Player2ManualControl(100, 0.5), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == '7')
    {
      player2ShipExists = true;
      new Capital(new Player2ManualControl(100, 0.5), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
    }
  }
}

public class SpawnControlListener extends EventListener<OnKeyChangedArgs>
{
  public void Recieve(OnKeyChangedArgs args)
  {
    if (args.affectedKey == '[')
    {
      SpawnAllies();
    }
    else if (args.affectedKey == ']')
    {
      SpawnEnemies();
    }
    else if (args.affectedKey == '\\')
    {
      Clear();
    } 
    else if (args.affectedKey == 'r')
    {
      new Fighter(new RallyAI(random(200, 250), random(0.5, 1), "fFaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == 't')
    {
      new CQC(new RallyAI(random(150, 200), random(0.5, 1), "qQaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == 'y')
    {
      new Frigate(new RallyAI(random(50, 150), random(1, 2), "cCaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == 'u')
    {
      new Capital(new RallyAI(random(50, 150), random(1, 2), "cCaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
    }
    else if (args.affectedKey == 'g')
    {
      new Fighter(new RandomAI(random(200, 250), random(0.5, 1)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
    }
    else if (args.affectedKey == 'h')
    {
      new CQC(new RandomAI(random(150, 200), random(0.5, 1)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
    }
    else if (args.affectedKey == 'j')
    {
      new Frigate(new RandomAI(random(50, 150), random(1, 2)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
    }
    else if (args.affectedKey == 'k')
    {
      new Capital(new RandomAI(random(50, 150), random(1, 2)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
    }
  }
}

public void SpawnEnemies()
{
  for (int i = 0; i < 15; i++)
  {
    new Fighter(new RandomAI(random(200, 250), random(0.5, 1)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
  }
  
  for (int i = 0; i < 10; i++)
  {
    new CQC(new RandomAI(random(150, 200), random(0.5, 1)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
  }
  
  for (int i = 0; i < 3; i++)
  {
    new Frigate(new RandomAI(random(50, 150), random(1, 2)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
  }
  
  for (int i = 0; i < 3; i++)
  {
    new Capital(new RandomAI(random(50, 150), random(1, 2)), new Point(random(0, width), random(0, height / 2)), ENEMY_TEAM, false);
  }
}

public void SpawnAllies()
{
  for (int i = 0; i < 15; i++)
  {
    new Fighter(new RallyAI(random(200, 250), random(0.5, 1), "fFaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
  }
  
  for (int i = 0; i < 10; i++)
  {
    new CQC(new RallyAI(random(150, 200), random(0.5, 1), "qQaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
  }
  
  for (int i = 0; i < 3; i++)
  {
    new Frigate(new RallyAI(random(50, 150), random(1, 2), "dDaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
  }
  
  for (int i = 0; i < 3; i++)
  {
    new Capital(new RallyAI(random(50, 150), random(1, 2), "cCaA"), new Point(random(0, width), random(height / 2, height)), PLAYER_TEAM, true);
  }
}

public void Clear()
{
  if (ships != null)
      for (int i = ships.size() - 1; i >= 0; i--)
        ships.get(i).Destroy();
  ships = new ArrayList();
  colliders = new ArrayList();
  if (projectiles != null)
      for (int i = projectiles.size() - 1; i >= 0; i--)
        projectiles.get(i).Destroy();
  projectiles = new ArrayList();
  updatables = new ArrayList();
}

public void setup() 
{
  noStroke();
  frameRate(80);
  //size(1280, 1024);
  fullScreen();
  SetupUtils();
  Clear();
  
  OnKeyReleased.AddListener(new SpawnPlayerShipKeyListener());
  OnKeyReleased.AddListener(new SpawnPlayer2ShipKeyListener());
  OnKeyReleased.AddListener(new SpawnControlListener());
  
  //new Frigate(new ManualControl(), new Point(width / 2f, height / 2f), PLAYER_TEAM, true);
  
  SpawnAllies();
  SpawnEnemies();
}

public void SetupUtils()
{
  Utils.pointUtil = new PointUtil();
  Utils.rectUtil = new RectUtil();
}

public void draw() 
{
  frameRate(16);
  clear();
  background(0,0,0);
  LoopColliders();
  LoopUpdatables();
  //rect1.rect.SetCenter(new Point(mouseX,mouseY));
  //println("Check Collision: " + rect1.rect);
  //println("With: " + rect2.rect);
  //println("Mouse x & y: " + mouseX + ", " + mouseY);
  //println("Rect1 center: " + rect1.rect.Center());
  //rect(rect1.rect.min.x, rect1.rect.min.y, rect1.rect.Size().x, rect1.rect.Size().y);
  //rect(rect2.rect.min.x, rect2.rect.min.y, rect2.rect.Size().x, rect2.rect.Size().y);
}

public void LoopUpdatables() 
{
  //RQLoop
  int i = updatables.size() - 1;
  while (i >= 0)
  {
    updatables.get(i).Update();
    i--;
  }
}

public void LoopColliders()
{
  for (int i = colliders.size() - 1; i >= 0; i--)
  {
    for (int j = colliders.size() - 1; j >= 0; j--)
    {
      if (j >= colliders.size())
        continue;
      if (i >= colliders.size())
        break;
      if(colliders.get(i) != colliders.get(j))
        colliders.get(i).Collide(colliders.get(j));
    }
    if (i >= colliders.size())
      continue;
  }
}
//Main End

//General
public class Point
{
  public float x;
  public float y;
  
  Point(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  public String toString() 
  {
    return x + ", " + y;
  }
  
  public Point Sum(Point other)
  {
    return new Point(this.x + other.x, this.y + other.y);
  }
  
  public Point Normalize()
  {
    float magnitude = Magnitude();
    return new Point(x / magnitude, y / magnitude);
  }
  
  public float Magnitude()
  {
    return sqrt(pow(x, 2) + pow(y, 2));
  }
  
  public Point Multiply(float amount)
  {
    return new Point(x * amount, y * amount);
  }
  
  public Point Clone()
  {
    return new Point(x, y);
  }
}

public class Rectangle
{
  public Point min;
  public Point max;
  
  public Rectangle(Point min, Point max)
  {
    if (min.x > max.x || min.y > max.y)
    {
      println("ERROR: Rectangle min x,y must be less than max x,y");
      println("ERROR: min: " + min);
      println("ERROR: max: " + max);
    }
    this.min = min;
    this.max = max;
  }
  
  public String toString() 
  {
    return "rect: " + min + " : " + max;
  }
  
  public Point Size()
  {
    return new Point(max.x - min.x, max.y - min.y);
  }
  
  public void SetSize(Point size)
  {
    max = min.Sum(size);
  }
  
  public void SetSizeCenter(Point size)
  {
    Point center = Center();
    min = new Point(center.x - size.x / 2f, center.y - size.y / 2f);
    max = new Point(center.x + size.x / 2f, center.y + size.y / 2);
  }
  
  public Point Center()
  {
    return new Point((min.x + max.x) / 2f, (min.y + max.y) / 2f);
  }
  
  public void SetCenter(Point center)
  {
    Point size = Size();
    min = new Point(center.x - size.x / 2f, center.y - size.y / 2f);
    max = new Point(center.x + size.x / 2f, center.y + size.y / 2);
    //min = center.Sum(size.Multiply(0.5));
    //max = center.Sum(size.Multiply(-0.5));
  }
}

public static class Utils
{
  public static PointUtil pointUtil;
  public static RectUtil rectUtil;
}

public class RectUtil
{
  public Rectangle NewFromCenterSize(Point center, Point size)
  {
    Rectangle rect = new Rectangle(new Point(0,0), size);
    rect.SetCenter(center);
    return rect;
  }
}

public class PointUtil
{
  public float Distance(Point p1, Point p2)
  {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }
  
  public Point GetVectorTo(Point start, Point end)
  {
    return new Point(end.x - start.x, end.y - start.y);
  }
    
  public boolean IsInsideScreen(Point point)
  {
    return point.x >= 0 && point.x <= width && point.y >= 0 && point.y <= height;
  }
}
//General End

//Observer Pattern
public abstract class EventArgs
{
  
}

public class NoArgs extends EventArgs
{
  
}

public abstract class EventListener<T extends EventArgs>
{
  public abstract void Recieve(T args);
  public boolean equals(Object o)
  {
    return o == this;
  }
}

public class Event<T extends EventArgs>
{
  private ArrayList<EventListener<T>> listeners;
  
  public Event()
  {
    listeners = new ArrayList();
  }
  
  public void Invoke(T args)
  {
    for(int i = listeners.size() - 1; i >= 0; i--)
    {
      listeners.get(i).Recieve(args);
    }
  }
  
  public void AddListener(EventListener<T> listener)
  {
    listeners.add(listener);
  }
  
  public void RemoveListener(EventListener<T> listener)
  {
    listeners.remove(listener);
  }
}
//Observer Pattern End

//ShipComponent
public class ShipComponent
{
  public Ship owner;
  
  public void Setup(Ship owner)
  {
    this.owner = owner;
  }
}
//ShipComponentEnd

//Collision
public abstract class Collider
{ 
  public OnCollideEvent OnCollide = new OnCollideEvent();
  public Object owner;
  
  public Collider(Object owner)
  {
    this.owner = owner;
  }
  
  public abstract void Collide(Collider other);
}

public class RectCollider extends Collider
{
  public Rectangle rect;
  
  public RectCollider(Object owner, Rectangle rect)
  {
    super(owner);
    this.rect = rect;
  }
  
  public void Collide(Collider other)
  {
    if (other instanceof RectCollider)
    {
      RectCollider collider = (RectCollider) other;
      if (rect.min.x < collider.rect.max.x &&
       rect.max.x > collider.rect.min.x &&
       rect.min.y < collider.rect.max.y &&
       rect.max.y > collider.rect.min.y) 
      {
        //println("Colliding: " + rect + " with " + collider.rect);
        OnCollide.Invoke(new OnCollideArgs(collider));
      }
    }
  }
}

public class OnCollideArgs extends EventArgs
{
  public Collider collidedWith;
  
  public OnCollideArgs(Collider collidedWith)
  {
    this.collidedWith = collidedWith;
  }
}

public class OnCollideEvent extends Event<OnCollideArgs>
{
  
}
//Collision Rect End

//HealthController
public class HealthController extends ShipComponent
{ 
  //Events
  public OnHealthChangeEvent OnHealthChange = new OnHealthChangeEvent();
  public OnDeathEvent OnDeath = new OnDeathEvent();
  
  public int maxHealth;
  public int health;
  
  public HealthController()
  {
    this(100);
  }
  
  public HealthController(int maxHealth)
  {
    this.maxHealth = maxHealth;
  }
  
  public void SetMaxHealth(int newMaxHealth)
  {
    maxHealth = newMaxHealth;
    health = maxHealth;
  }
  
  public void Damage(int amount)
  {
    if (amount == 0)
      return;
      
    health -= amount;
    if (health < 0) 
    {
      health = 0;
      OnDeath.Invoke(new NoArgs());
    }
    OnHealthChange.Invoke(new OnHealthChangeArgs(-amount));
  }
  
  public void Heal(int amount)
  {
    if (amount == 0)
      return;
      
    health += amount;
    if (health > maxHealth) 
    {
      health = maxHealth;
    }
    OnHealthChange.Invoke(new OnHealthChangeArgs(amount));
  }
}

public class OnHealthChangeArgs extends EventArgs
{
  public int amount;
  
  public OnHealthChangeArgs(int amount)
  {
    this.amount = amount;
  }
}

public class OnHealthChangeEvent extends Event<OnHealthChangeArgs>
{
  
}

public class OnDeathEvent extends Event<NoArgs>
{
  
}
//HealthController End

//Controller
public abstract class Controller extends ShipComponent
{
  public abstract void Update();
  public void Destroy()
  {
    
  }
}

public class RandomAI extends Controller 
{
  public float fireDelay;
  public float speed;
  public Point targetPosition;
  
  private float timer = 0;
  
  public RandomAI(float speed, float fireDelay)
  {
    this.fireDelay = fireDelay;
    this.speed = speed;
    targetPosition = new Point(random(0, width), random(0, height));
  }

  public void Update()
  {
    timer += 1f/frameRate;
    if (timer >= fireDelay)
    {
      timer = 0;
      owner.Fire();
    }
    if (Utils.pointUtil.Distance(owner.position, targetPosition) < speed * 1f/frameRate)
      targetPosition = new Point(random(0, width), random(0, height));
    Point vector = Utils.pointUtil.GetVectorTo(owner.position, targetPosition).Normalize().Multiply(speed * 1f/frameRate);
    owner.position = owner.position.Sum(vector);
  }
}

public class RallyAI extends Controller 
{
  public float fireDelay;
  public float speed;
  public Point targetPosition;
  
  public String rallyChars;
  
  private float timer = 0;
  
  private boolean rallying;
  private float stayTimer = 0;
  private float stayDelay;
  
  private RallyKeyListener listener;
  
  public RallyAI(float speed, float fireDelay, String rallyChars)
  {
    this.rallyChars = rallyChars;
    this.fireDelay = fireDelay;
    this.speed = speed;
    targetPosition = new Point(random(0, width), random(0, height));
    
    listener = new RallyKeyListener(this);
    OnKeyReleased.AddListener(listener);
  }
  
  public void Rally(Point rallyPosition, float radius, float stayDelay)
  {
    rallying = true;
    stayTimer = 0;
    this.stayDelay = stayDelay;
    targetPosition = new Point(rallyPosition.x + radius * cos(random(0,2*PI)), rallyPosition.y + radius * sin(random(0,2*PI)));
  }
  
  public void Destroy()
  {
    OnKeyPressed.RemoveListener(listener);
  }

  public void Update()
  {
    timer += 1f/frameRate;
    if (timer >= fireDelay)
    {
      timer = 0;
      owner.Fire();
    }
    if (Utils.pointUtil.Distance(owner.position, targetPosition) < speed * 1f/frameRate) 
    {
      if (rallying)
      {
        stayTimer += 1f/frameRate * stayDelay;
        if (stayTimer >= stayDelay)
          rallying = false;
      } else
        targetPosition = new Point(random(0, width), random(0, height));
    } 
    else 
    {
      Point vector = Utils.pointUtil.GetVectorTo(owner.position, targetPosition).Normalize().Multiply(speed * 1f/frameRate);
      owner.position = owner.position.Sum(vector);
    }
  }
}

public class RallyKeyListener extends EventListener<OnKeyChangedArgs>
{
  public RallyAI rallyAI;
  
  public RallyKeyListener(RallyAI rallyAI)
  {
    this.rallyAI = rallyAI;
  }
  
  public void Recieve(OnKeyChangedArgs args)
  {
    if (rallyAI.rallyChars.contains(Character.toString(args.affectedKey)))
      rallyAI.Rally(new Point(mouseX, mouseY), 100, 5);
  }
}

public class ManualControl extends Controller 
{   
  private ManualControlFireListener listener;
  
  public ManualControl()
  {
    listener = new ManualControlFireListener(this);
    OnMousePressed.AddListener(listener);
  }
  
  public void Update()
  {
    //RQMouseMovement
    owner.position = new Point(mouseX, mouseY);
  }
  
  public void Fire()
  {
    owner.Fire();
  }
  
  public void Destroy()
  {
    OnMousePressed.RemoveListener(listener);
    playerShipExists = false;
  }
}

public class ManualControlFireListener extends EventListener<OnMouseChangedArgs>
{
  public ManualControl manualControl;
  
  public ManualControlFireListener(ManualControl manualControl)
  {
    this.manualControl = manualControl;
  }
  
  public void Recieve(OnMouseChangedArgs args)
  {
    if (args.affectedButton == LEFT)
      manualControl.Fire();
  }
}

public class Player2ManualControl extends Controller 
{   
  public float speed;
  public float fireDelay;
  
  private float fireTimer;
  
  public Player2ManualControl(float speed, float fireDelay)
  {
    this.speed = speed;
    this.fireDelay = fireDelay;
    fireTimer = 0;
  }
  
  public void Update()
  {
    fireTimer += 1f/frameRate;
    
    if (fireTimer >= fireDelay)
    {
      fireTimer = 0;
      Fire();
    }
    
    //RQArrowKeys
    if (key == CODED)
    {
      if ((owner.position.y - speed * 1f/frameRate > 0) && keyCode == UP)
        owner.position.y -= speed * 1f/frameRate;
      else if ((owner.position.x - speed * 1f/frameRate > 0) && keyCode == LEFT)
        owner.position.x -= speed * 1f/frameRate;
      else if ((owner.position.y + speed * 1f/frameRate < height) && keyCode == DOWN)
        owner.position.y += speed * 1f/frameRate;
      else if ((owner.position.x + speed * 1f/frameRate < width) && keyCode == RIGHT)
        owner.position.x += speed * 1f/frameRate;
    }
  }
  
  public void Fire()
  {
    owner.Fire();
  }
  
  public void Destroy()
  {
    player2ShipExists = false;
  }
}
//Controller End

public interface IDrawable 
{
  void Draw();
}

public interface IUpdatable 
{
  void Update();
}

public interface IDestructable
{
  void Destroy();
}

//Projectile
public abstract class Projectile implements IUpdatable, IDrawable, IDestructable
{
  public OnProjectileDeath OnProjectileDeath = new OnProjectileDeath();
  
  public int team;
  public int damage;
  public Point position;
  public RelativeDrawer drawer;
  
  public abstract boolean Damage(Ship ship);
  public abstract boolean CanDamage(Ship ship);
  
  public Projectile(Point position, int damage, int team, boolean faceUp)
  {
    this.position = position;
    this.damage = damage;
    this.team = team;
    drawer = new RelativeDrawer(position, faceUp);
    
    updatables.add(this);
    projectiles.add(this);
  }
  
  public void Update() 
  {
    drawer.Update(position);
    Draw();
  }
  
  public void Destroy()
  {
    updatables.remove(this);
    projectiles.remove(this);
    OnProjectileDeath.Invoke(new OnProjectileDeathArgs(this));
  }
}

public class OnProjectileDeathArgs extends EventArgs
{
  public Projectile dyingProjectile;
  
  public OnProjectileDeathArgs(Projectile dyingProjectile)
  {
    this.dyingProjectile = dyingProjectile;
  }
}

public class OnProjectileDeath extends Event<OnProjectileDeathArgs>
{
  
}

public class OnProjectileCollideListener extends EventListener<OnCollideArgs>
{
  public Projectile projectile;
  
  public OnProjectileCollideListener(Projectile projectile)
  {
    this.projectile = projectile;
  }
  
  public void Recieve(OnCollideArgs args)
  {
    if (args.collidedWith.owner instanceof Ship)
    {
      Ship ship = (Ship) args.collidedWith.owner;
      if (projectile.CanDamage(ship))
      {
        projectile.Damage(ship);
        projectile.Destroy();
      }
    }
  }
}

public class StandardProjectile extends Projectile
{
  public float speed;
  public RectCollider collider;
  
  private OnProjectileCollideListener listener;
  
  public StandardProjectile(Point position, int damage, int team, boolean faceUp, float speed)
  {
    super(position, damage, team, faceUp);
    this.speed = speed;
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(10, 20)));
    colliders.add(collider);
    listener = new OnProjectileCollideListener(this);
    collider.OnCollide.AddListener(listener);
  }
  
  public boolean Damage(Ship ship)
  {
    ship.healthController.Damage(damage);
    return CanDamage(ship);
  }
  
  public boolean CanDamage(Ship ship)
  {
    return ship.team != team;
  }
  
  public void Update()
  {
    super.Update();
    if (drawer.faceUp)
      position.y -= speed;
    else
      position.y += speed;
      
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
    
    if (!Utils.pointUtil.IsInsideScreen(position))
      Destroy();
  }
  
  public void Destroy()
  {
    collider.OnCollide.RemoveListener(listener);
    colliders.remove(collider);
    super.Destroy();
  }
  
  public void Draw()
  {
    fill(TEAM_COLORS[team][1]);
    drawer.RelativeCenterRect(new Point(0, 0), new Point(10, 20));
  }
}

public class CircleProjectile extends Projectile
{
  public float angle;
  public float speed;
  public RectCollider collider;
  
  private OnProjectileCollideListener listener;
  
  public CircleProjectile(Point position, int damage, int team, boolean faceUp, float speed, float angle)
  {
    super(position, damage, team, faceUp);
    this.angle = angle;
    this.speed = speed;
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(20, 20)));
    colliders.add(collider);
    listener = new OnProjectileCollideListener(this);
    collider.OnCollide.AddListener(listener);
  }
  
  public boolean Damage(Ship ship)
  {
    ship.healthController.Damage(damage);
    return CanDamage(ship);
  }
  
  public boolean CanDamage(Ship ship)
  {
    return ship.team != team;
  }
  
  public void Update()
  {
    super.Update();
    if (drawer.faceUp) {
      position.x -= cos(radians(angle)) * speed;
      position.y -= sin(radians(angle)) * speed;
    }
    else 
    {
      position.x += cos(radians(angle)) * speed;
      position.y += sin(radians(angle)) * speed;
    }
      
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
    
    if (!Utils.pointUtil.IsInsideScreen(position))
      Destroy();
  }
  
  public void Destroy()
  {
    collider.OnCollide.RemoveListener(listener);
    colliders.remove(collider);
    super.Destroy();
  }
  
  public void Draw()
  {
    fill(TEAM_COLORS[team][1]);
    drawer.RelativeEllipse(new Point(0, 0), new Point(20, 20));
  }
}
//Projectile End

public class RelativeDrawer
{
  public boolean faceUp;
  public Point position;
  
  public RelativeDrawer(Point position, boolean faceUp)
  {
    this.position = position;
    this.faceUp = faceUp;
  }
  
  public void Update(Point position)
  {
    this.position = position;
  }
  
  public void RelativeCenterRect(Point relativePosition, Point size) 
  {
    RelativeRect(new Point(relativePosition.x - size.x / 2, relativePosition.y - size.y / 2), new Point(relativePosition.x + size.x / 2, relativePosition.y + size.y / 2));
  }
  
  public void RelativeRect(Point relativePosition, Point relativePosition2) 
  {
    RelativeRect(new Rectangle(relativePosition, relativePosition2));
  }
  
  public void RelativeRect(Rectangle rect) 
  {
    if (!faceUp)
      rect = new Rectangle(rect.max.Multiply(-1), rect.min.Multiply(-1));
    rect(position.x + rect.min.x, position.y + rect.min.y, rect.max.x - rect.min.x, rect.max.y - rect.min.y);
  }
  
  public void RelativeEllipse(Point relativePosition, float circleWidth, float circleHeight) 
  {
    RelativeEllipse(relativePosition, new Point(circleWidth, circleHeight));
  }
  
  public void RelativeEllipse(Point relativePosition, Point size) 
  {
    if (!faceUp)
      relativePosition = relativePosition.Multiply(-1);
    ellipse(position.x + relativePosition.x, position.y + relativePosition.y, size.x, size.y);
  }
  
  public void RelativeTriangle(Point point1, Point point2, Point point3)
  {
    if (!faceUp) 
    {
      point1 = point1.Multiply(-1);
      point2 = point2.Multiply(-1);
      point3 = point3.Multiply(-1);
    }
    triangle(
      position.x + point1.x, position.y + point1.y,
      position.x + point2.x, position.y + point2.y, 
      position.x + point3.x, position.y + point3.y
      );
  }
}

//Ship
public abstract class Ship implements IDrawable, IUpdatable, IDestructable
{
  //Events
  public OnShipDeath OnShipDeath = new OnShipDeath();
  
  public HealthController healthController;
  public Controller controller;
  public Collider collider;
  public Point position;
  public int team;
  public RelativeDrawer drawer;
  
  private HealthDeathToShipDeath listener;
  
  public Ship(Controller controller, Point position, int team) 
  {
    this(controller, position, team, true);
  }
  
  public Ship(Controller controller, Point position, int team, boolean faceUp)
  {
    this.team = team;
    this.controller = controller;
    controller.Setup(this);
    this.position = position;
    healthController = new HealthController();
    listener = new HealthDeathToShipDeath(this);
    healthController.OnDeath.AddListener(listener);
    drawer = new RelativeDrawer(position, faceUp);
    
    updatables.add(this);
    ships.add(this);
  }
  
  public void Update()
  {
    drawer.Update(position);
    controller.Update();
    Draw();
  }
  
  public abstract void Draw();
  public abstract void Fire();
  
  public void Destroy()
  {
    controller.Destroy();
    healthController.OnDeath.RemoveListener(listener);
    updatables.remove(this);
    ships.remove(this);
    colliders.remove(collider);
    
    OnShipDeath.Invoke(new OnShipDeathArgs(this));
  }
}

public class OnShipDeathArgs extends EventArgs
{
  public Ship dyingShip;
  
  public OnShipDeathArgs(Ship dyingShip)
  {
    this.dyingShip = dyingShip;
  }
}

public class OnShipDeath extends Event<OnShipDeathArgs>
{
  
}

public class HealthDeathToShipDeath extends EventListener<NoArgs>
{
  public Ship ship;
  
  public HealthDeathToShipDeath(Ship ship)
  {
    this.ship = ship;
  }
  
  public void Recieve(NoArgs args)
  {
    ship.Destroy();
  }
}

public class Fighter extends Ship 
{
  public Fighter(Controller controller, Point position, int team)
  {
    this(controller, position, team, true);
  }
  
  public Fighter(Controller controller, Point position, int team, boolean faceUp)
  {
    super(controller, position, team, faceUp);
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(40, 50)));
    colliders.add(collider);
    healthController.SetMaxHealth(100);
  }
  
  public void Destroy()
  {
    colliders.remove(collider);
    for (int i = 0; i < 5; i++)
      new Explosion(new Point(random(position.x - 20, position.x + 20), random(position.y - 25, position.y + 25)), random(0.5f, 1f), random(25, 75));
    super.Destroy();
  }
  
  public void Update()
  {
    super.Update();
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
  }
  
  public void Draw() 
  {
    fill(TEAM_COLORS[team][0]);
    drawer.RelativeTriangle(new Point(0, -30), new Point(-15, 20), new Point(15, 20));
    drawer.RelativeCenterRect(new Point(0, 20), new Point(20, 5));
    fill(TEAM_COLORS[team][1]);
    drawer.RelativeCenterRect(new Point(0, 25), new Point(20, 2.5));
    drawer.RelativeTriangle(new Point(-30, 20 - 10), new Point(-15, 20 - 10), new Point(-15, 0 - 10));
    drawer.RelativeTriangle(new Point(30, 20 - 10), new Point(15, 20 - 10), new Point(15, 0 - 10));
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeTriangle(new Point(-30, 20), new Point(-15, 20), new Point(-15, 0));
    drawer.RelativeTriangle(new Point(30, 20), new Point(15, 20), new Point(15, 0));

    /*fill(255, 0, 0);
    RectCollider rectCollider = (RectCollider) collider;
    rect(rectCollider.rect.min.x, rectCollider.rect.min.y, rectCollider.rect.max.x - rectCollider.rect.min.x, rectCollider.rect.max.y - rectCollider.rect.min.y);
    fill(255, 255, 255);*/
  }
  
  public void Fire()
  {
    new StandardProjectile(new Point(position.x - 10, position.y), 10, team, drawer.faceUp, 15);
    new StandardProjectile(new Point(position.x + 10, position.y), 10, team, drawer.faceUp, 15);
  }
}

public class CQC extends Ship 
{
  public CQC(Controller controller, Point position, int team)
  {
    this(controller, position, team, true);
  }
  
  public CQC(Controller controller, Point position, int team, boolean faceUp)
  {
    super(controller, position, team, faceUp);
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(40, 50)));
    colliders.add(collider);
    healthController.SetMaxHealth(100);
  }
  
  public void Destroy()
  {
    colliders.remove(collider);
    for (int i = 0; i < 5; i++)
      new Explosion(new Point(random(position.x - 20, position.x + 20), random(position.y - 25, position.y + 25)), random(0.5f, 1f), random(25, 75));
    super.Destroy();
  }
  
  public void Update()
  {
    super.Update();
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
  }
  
  public void Draw() 
  {
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeTriangle(new Point(0, -20-15), new Point(-15, 20-15), new Point(15, 20-15));
    fill(TEAM_COLORS[team][0]);
    drawer.RelativeTriangle(new Point(0, -20), new Point(-15, 20), new Point(15, 20));
    drawer.RelativeCenterRect(new Point(0, 20), new Point(20, 5));
    fill(TEAM_COLORS[team][1]);
    drawer.RelativeCenterRect(new Point(0, 25), new Point(20, 2.5));
    drawer.RelativeTriangle(new Point(-30, 20 - 10), new Point(-15, 20 - 10), new Point(-15, 0 - 20));
    drawer.RelativeTriangle(new Point(30, 20 - 10), new Point(15, 20 - 10), new Point(15, 0 - 20));
    drawer.RelativeTriangle(new Point(-30, 20), new Point(-15, 20), new Point(-15, 30));
    drawer.RelativeTriangle(new Point(30, 20), new Point(15, 20), new Point(15, 30));
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeTriangle(new Point(-30, 20), new Point(-15, 20), new Point(-15, 0));
    drawer.RelativeTriangle(new Point(30, 20), new Point(15, 20), new Point(15, 0));

    /*fill(255, 0, 0);
    RectCollider rectCollider = (RectCollider) collider;
    rect(rectCollider.rect.min.x, rectCollider.rect.min.y, rectCollider.rect.max.x - rectCollider.rect.min.x, rectCollider.rect.max.y - rectCollider.rect.min.y);
    fill(255, 255, 255);*/
  }
  
  public void Fire()
  {
    new CircleProjectile(new Point(position.x, position.y), 5, team, drawer.faceUp, 15, 90 - 20);
    new CircleProjectile(new Point(position.x, position.y), 5, team, drawer.faceUp, 15, 90 - 10);
    new CircleProjectile(new Point(position.x, position.y), 5, team, drawer.faceUp, 15, 90);
    new CircleProjectile(new Point(position.x, position.y), 5, team, drawer.faceUp, 15, 90 + 10);
    new CircleProjectile(new Point(position.x, position.y), 5, team, drawer.faceUp, 15, 90 + 20);
  }
}

public class Frigate extends Ship 
{
  public Frigate(Controller controller, Point position, int team)
  {
    this(controller, position, team, true);
  }
  
  public Frigate(Controller controller, Point position, int team, boolean faceUp)
  {
    super(controller, position, team, faceUp);
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(75, 250)));
    colliders.add(collider);
    healthController.SetMaxHealth(250);
  }
  
  public void Destroy()
  {
    for (int i = 0; i < 10; i++)
      new Explosion(new Point(random(position.x - 40, position.x + 40), random(position.y - 190, position.y + 190)), random(0.5f, 1f), random(100, 200));
    for (int i = 0; i < 10; i++)
      new Explosion(new Point(random(position.x - 40, position.x + 40), random(position.y - 190, position.y + 190)), random(0.5f, 1f), random(25, 50));
    colliders.remove(collider);
    super.Destroy();
  }
  
  public void Update()
  {
    super.Update();
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
  }
  
  public void Draw() 
  {
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeCenterRect(new Point(0, 125), new Point(50, 10));
    
    drawer.RelativeCenterRect(new Point(25+6.25, 0), new Point(12.5, 250));
    drawer.RelativeCenterRect(new Point(-25-6.25, 0), new Point(12.5, 250));
    fill(TEAM_COLORS[team][0]);
    drawer.RelativeCenterRect(new Point(0, 0), new Point(50, 250));
    fill(TEAM_COLORS[team][1]);    
    drawer.RelativeCenterRect(new Point(0, 60), new Point(85, 10));
    drawer.RelativeCenterRect(new Point(0, 30), new Point(85, 10));
    
    drawer.RelativeEllipse(new Point(0, -25), new Point(40, 40));
    
    drawer.RelativeCenterRect(new Point(0, 135), new Point(50, 5));
    drawer.RelativeCenterRect(new Point(0, 150), new Point(50, 10));
    fill(TEAM_COLORS[team][2]);    
    drawer.RelativeEllipse(new Point(0, -85), new Point(40, 40));
    
    drawer.RelativeEllipse(new Point(0, -25), new Point(30, 30));
    
    drawer.RelativeCenterRect(new Point(0, 20), new Point(50, 15));
    drawer.RelativeCenterRect(new Point(0, 70), new Point(50, 15));
    drawer.RelativeCenterRect(new Point(0, 110), new Point(50, 15));
    fill(TEAM_COLORS[team][3]);
    drawer.RelativeEllipse(new Point(0, -85), new Point(30, 30));
    
    drawer.RelativeCenterRect(new Point(35, 20), new Point(25, 15));
    drawer.RelativeCenterRect(new Point(-35, 20), new Point(25, 15));
    
    drawer.RelativeCenterRect(new Point(35, 70), new Point(25, 15));
    drawer.RelativeCenterRect(new Point(-35, 70), new Point(25, 15));
    
    drawer.RelativeCenterRect(new Point(35, 110), new Point(25, 15));
    drawer.RelativeCenterRect(new Point(-35, 110), new Point(25, 15));
    
    drawer.RelativeCenterRect(new Point(0, -130), new Point(50, 10));

    /*fill(255, 0, 0);
    RectCollider rectCollider = (RectCollider) collider;
    rect(rectCollider.rect.min.x, rectCollider.rect.min.y, rectCollider.rect.max.x - rectCollider.rect.min.x, rectCollider.rect.max.y - rectCollider.rect.min.y);
    fill(255, 255, 255);*/
  }
  
  public void Fire()
  {
    float scale = 1;
    if (!drawer.faceUp)
      scale = -1;
    new CircleProjectile(new Point(position.x - 50, position.y - 75 * scale), 5, team, drawer.faceUp, 17.5, 90 - 30 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y - 75 * scale), 5, team, drawer.faceUp, 17.5, 90 + 30 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y), 5, team, drawer.faceUp, 15, 90 - 50 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y), 5, team, drawer.faceUp, 15, 90 + 50 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 50 * scale), 5, team, drawer.faceUp, 12.5, 90 - 70 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 50 * scale), 5, team, drawer.faceUp, 12.5, 90 + 70 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 100 * scale), 5, team, drawer.faceUp, 10, 90 - 90 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 100 * scale), 5, team, drawer.faceUp, 10, 90 + 90 * scale);
    
    new StandardProjectile(new Point(position.x - 12.5, position.y - 125 * scale), 10, team, drawer.faceUp, 15);
    new StandardProjectile(new Point(position.x + 12.5, position.y - 125 * scale), 10, team, drawer.faceUp, 15);
    
    new StandardProjectile(new Point(position.x - 12.5, position.y - 125 * scale), 10, team, drawer.faceUp, 10);
    new StandardProjectile(new Point(position.x + 12.5, position.y - 125 * scale), 10, team, drawer.faceUp, 10);
    
  }
}

public class Capital extends Ship 
{
  public Capital(Controller controller, Point position, int team)
  {
    this(controller, position, team, true);
  }
  
  public Capital(Controller controller, Point position, int team, boolean faceUp)
  {
    super(controller, position, team, faceUp);
    collider = new RectCollider(this, Utils.rectUtil.NewFromCenterSize(position, new Point(100, 400)));
    colliders.add(collider);
    healthController.SetMaxHealth(500);
  }
  
  public void Destroy()
  {
    for (int i = 0; i < 10; i++)
      new Explosion(new Point(random(position.x - 40, position.x + 40), random(position.y - 190, position.y + 190)), random(0.5f, 1f), random(100, 200));
    for (int i = 0; i < 10; i++)
      new Explosion(new Point(random(position.x - 40, position.x + 40), random(position.y - 190, position.y + 190)), random(0.5f, 1f), random(25, 50));
    colliders.remove(collider);
    super.Destroy();
  }
  
  public void Update()
  {
    super.Update();
    RectCollider rectCollider = (RectCollider) collider;
    rectCollider.rect.SetCenter(position);
  }
  
  public void Draw() 
  {
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeCenterRect(new Point(25, 200), new Point(40, 10));
    drawer.RelativeCenterRect(new Point(-25, 200), new Point(40, 10));
    drawer.RelativeCenterRect(new Point(-35, 0), new Point(30, 400));
    drawer.RelativeCenterRect(new Point(35, 0), new Point(30, 400));
    fill(TEAM_COLORS[team][0]);
    drawer.RelativeCenterRect(new Point(0, 0), new Point(50, 400));
    fill(TEAM_COLORS[team][1]);    
    drawer.RelativeCenterRect(new Point(0, -30), new Point(125, 15));
    drawer.RelativeCenterRect(new Point(0, 0), new Point(125, 15));
    drawer.RelativeCenterRect(new Point(0, 30), new Point(125, 15));
    
    drawer.RelativeEllipse(new Point(0, -100), new Point(40, 40));
    drawer.RelativeEllipse(new Point(0, 100), new Point(40, 40));
    
    drawer.RelativeCenterRect(new Point(25, 210), new Point(40, 5));
    drawer.RelativeCenterRect(new Point(-25, 210), new Point(40, 5));
    drawer.RelativeCenterRect(new Point(25, 225), new Point(40, 10));
    drawer.RelativeCenterRect(new Point(-25, 225), new Point(40, 10));
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeEllipse(new Point(0, -150), new Point(40, 40));
    drawer.RelativeEllipse(new Point(0, 150), new Point(40, 40));
    fill(TEAM_COLORS[team][3]);
    drawer.RelativeCenterRect(new Point(0, -205), new Point(75, 10));
    
    drawer.RelativeCenterRect(new Point(-50, 135), new Point(30, 50));
    drawer.RelativeCenterRect(new Point(50, 135), new Point(30, 50));
    
    drawer.RelativeCenterRect(new Point(-50, -125), new Point(30, 75));
    drawer.RelativeCenterRect(new Point(50, -125), new Point(30, 75));
    
    drawer.RelativeCenterRect(new Point(0, -45), new Point(125, 25));
    drawer.RelativeCenterRect(new Point(0, 0), new Point(125, 25));
    drawer.RelativeCenterRect(new Point(0, 45), new Point(125, 25));
    
    drawer.RelativeEllipse(new Point(0, -150), new Point(30, 30));
    drawer.RelativeEllipse(new Point(0, 150), new Point(30, 30));
    fill(TEAM_COLORS[team][2]);
    drawer.RelativeCenterRect(new Point(0, -45), new Point(75, 25));
    drawer.RelativeCenterRect(new Point(0, 0), new Point(75, 25));
    drawer.RelativeCenterRect(new Point(0, 45), new Point(75, 25));
    
    drawer.RelativeEllipse(new Point(0, -100), new Point(30, 30));
    drawer.RelativeEllipse(new Point(0, 100), new Point(30, 30));

    /*fill(255, 0, 0);
    RectCollider rectCollider = (RectCollider) collider;
    rect(rectCollider.rect.min.x, rectCollider.rect.min.y, rectCollider.rect.max.x - rectCollider.rect.min.x, rectCollider.rect.max.y - rectCollider.rect.min.y);
    fill(255, 255, 255);*/
  }
  
  public void Fire()
  {
    float scale = 1;
    if (!drawer.faceUp)
      scale = -1;
    new CircleProjectile(new Point(position.x - 50, position.y - 150 * scale), 5, team, drawer.faceUp, 20, 90 - 45 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y - 150 * scale), 5, team, drawer.faceUp, 20, 90 + 45 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y - 75 * scale), 5, team, drawer.faceUp, 17.5, 90 - 45 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y - 75 * scale), 5, team, drawer.faceUp, 17.5, 90 + 45 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y), 5, team, drawer.faceUp, 15, 90 - 45 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y), 5, team, drawer.faceUp, 15, 90 + 45 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 75 * scale), 5, team, drawer.faceUp, 12.5, 90 - 45 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 75 * scale), 5, team, drawer.faceUp, 12.5, 90 + 45 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 150 * scale), 5, team, drawer.faceUp, 10, 90 - 45 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 150 * scale), 5, team, drawer.faceUp, 10, 90 + 45 * scale);
    
    new StandardProjectile(new Point(position.x - 20, position.y - 200 * scale), 10, team, drawer.faceUp, 15);
    new StandardProjectile(new Point(position.x, position.y - 200 * scale), 10, team, drawer.faceUp, 15);
    new StandardProjectile(new Point(position.x + 20, position.y - 200 * scale), 10, team, drawer.faceUp, 15);
    
    new StandardProjectile(new Point(position.x - 20, position.y - 200 * scale), 10, team, drawer.faceUp, 10);
    new StandardProjectile(new Point(position.x, position.y - 200 * scale), 10, team, drawer.faceUp, 10);
    new StandardProjectile(new Point(position.x + 20, position.y - 200 * scale), 10, team, drawer.faceUp, 10);
    
    new StandardProjectile(new Point(position.x - 20, position.y - 200 * scale), 10, team, drawer.faceUp, 5);
    new StandardProjectile(new Point(position.x, position.y - 200 * scale), 10, team, drawer.faceUp, 5);
    new StandardProjectile(new Point(position.x + 20, position.y - 200 * scale), 10, team, drawer.faceUp, 5);
    
    new CircleProjectile(new Point(position.x - 50, position.y - 125 * scale), 5, team, drawer.faceUp, 10, 90 - 135 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y - 125 * scale), 5, team, drawer.faceUp, 10, 90 + 135 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y - 50 * scale), 5, team, drawer.faceUp, 15, 90 - 135 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y - 50 * scale), 5, team, drawer.faceUp, 15, 90 + 135 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 50 * scale), 5, team, drawer.faceUp, 15, 90 - 135 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 50 * scale), 5, team, drawer.faceUp, 15, 90 + 135 * scale);
    
    new CircleProjectile(new Point(position.x - 50, position.y + 125 * scale), 5, team, drawer.faceUp, 10, 90 - 135 * scale);
    new CircleProjectile(new Point(position.x + 50, position.y + 125 * scale), 5, team, drawer.faceUp, 10, 90 + 135 * scale);
  }
}
//Ship End

//Explosion
public class Explosion implements IUpdatable, IDrawable, IDestructable
{
  private RelativeDrawer drawer;
  private float timer;
  private float duration;
  private color explosionColor;
  private float size;
  
  public Explosion(Point position, float duration, float size)
  {
    drawer = new RelativeDrawer(position, true);
    this.duration = duration;
    this.size = size;
    
    switch((int) random(0, 3))
    {
      case 0:
        explosionColor = color(255, 150, 0);
        break;
      case 1:
        explosionColor = color(255, 255, 0);
        break;
      case 2:
        explosionColor = color(255, 255, 255);
        break;
    }
    
    timer = 0;
    
    updatables.add(this);
  }
  
  public void Update()
  {
    if (timer >= duration)
     Destroy();
    timer += 1f/frameRate;
    Draw();
  }
  
  public void Draw()
  {
    fill(explosionColor);
    drawer.RelativeEllipse(new Point(0, 0), new Point(size * (1 - timer / duration), size * (1 - timer / duration)));
  }
  
  public void Destroy()
  {
    updatables.remove(this);
  }
}
//ExplosionEnd
