import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../modules/city_module/city_controller.dart';
class AudioPad extends StatefulWidget {
  final CityController controller;
  final PlayerState state;
  const AudioPad({Key? key, required this.controller, required this.state,}) : super(key: key);

  @override
  State<AudioPad> createState() => _AudioPadState();
}

class _AudioPadState extends State<AudioPad> {
  @override
  Widget build(BuildContext context) {
    return !isPaint()?Container():Container(
      child:FloatingActionButton(
        backgroundColor: Colors.transparent,
        child:getIcon(),
        onPressed: (){
          switch(widget.controller.playerState()){
            case PlayerState.playing:
              widget.controller.pausePlayer();
              break;
            case PlayerState.completed:
              break;
            case PlayerState.paused:
              widget.controller.resumePlayer();
              break;
            case PlayerState.stopped:
              widget.controller.resumePlayer();
              break;
          }
        },
      )
    );
  }

  bool isPaint(){
    return widget.state!=PlayerState.completed;
  }

  Icon getIcon(){

    print(widget.state.toString());
    switch(widget.state){
      case PlayerState.playing:
        return const Icon(Icons.stop_circle_outlined,size: 55,);
        break;
      default:
        return const Icon(Icons.play_circle_outlined,size: 55,);
    }
  }

}
