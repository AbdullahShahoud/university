import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/hub_models.dart';
import '../../data/repo/hub_repository.dart';

class HubState {
  final List<HubEvent> events;
  final List<HubJob> jobs;
  final List<HubTraining> trainings;
  final bool isLoading;
  final String? errorMessage;

  HubState({
    required this.events,
    required this.jobs,
    required this.trainings,
    required this.isLoading,
    this.errorMessage,
  });

  factory HubState.initial() {
    return HubState(
      events: [],
      jobs: [],
      trainings: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  HubState copyWith({
    List<HubEvent>? events,
    List<HubJob>? jobs,
    List<HubTraining>? trainings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HubState(
      events: events ?? this.events,
      jobs: jobs ?? this.jobs,
      trainings: trainings ?? this.trainings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HubCubit extends Cubit<HubState> {
  final HubRepository _repository;

  HubCubit(this._repository) : super(HubState.initial()) {
    loadHubData();
  }

  Future<void> loadHubData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final eventsResult = await _repository.getEvents();
    final jobsResult = await _repository.getJobs();
    final trainingsResult = await _repository.getTrainings();

    String? errorMessage;
    List<HubEvent> events = [];
    List<HubJob> jobs = [];
    List<HubTraining> trainings = [];

    eventsResult.when(
      success: (data) => events = data,
      failure: (error) => errorMessage = error.message,
    );

    if (errorMessage != null) {
      emit(state.copyWith(errorMessage: errorMessage, isLoading: false));
      return;
    }

    jobsResult.when(
      success: (data) => jobs = data,
      failure: (error) => errorMessage = error.message,
    );

    if (errorMessage != null) {
      emit(state.copyWith(errorMessage: errorMessage, isLoading: false));
      return;
    }

    trainingsResult.when(
      success: (data) => trainings = data,
      failure: (error) => errorMessage = error.message,
    );

    if (errorMessage != null) {
      emit(state.copyWith(errorMessage: errorMessage, isLoading: false));
      return;
    }

    emit(
      state.copyWith(
        events: events,
        jobs: jobs,
        trainings: trainings,
        isLoading: false,
      ),
    );
  }

  Future<void> reload() => loadHubData();
}
