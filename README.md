# wiimote-ros-docker

Necessary files for building a docker image to use wiimote controller to control a robot.

## Usage

### Building the image

```
make build
```

### Building the ROS nodes

```
docker-compose up catkin-make
```

### (Optional) Launching `roscore`

```
docker-compose up master
```

If a ROS master is already present in the host machine, this is not necessary

### Launching `wiimote` node to get `Joy` messages from the wiimote controller

```
docker-compose up run-wiimote
```

### Launching `wiimote_teleop_node` to convert the `Joy` messages to `Twist` messages

```
docker-compose up run-teleop
```
