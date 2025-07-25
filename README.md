# FPGA Learning Journey

![FPGA](https://img.shields.io/badge/FPGA-NEXYS%20A7-blue)
![Language](https://img.shields.io/badge/Language-Verilog-orange)
![Status](https://img.shields.io/badge/Status-Complete-green)

## 📋 프로젝트 개요
- **기간**: 2024년 6월 24일 ~ 7월 24일 (1개월)
- **보드**: Nexys 4 Artix-7 FPGA
- **개발환경**: Xilinx Vivado
- **목표**: 단계별 FPGA 설계 학습 - 7-segment 스톱워치부터 VGA+UART 틱택토 게임까지

이 프로젝트는 FPGA 입문자를 위한 체계적인 학습 과정으로, 기본적인 디지털 회로 설계부터 복합적인 시스템 통합까지 단계별로 구성되었습니다.

## 🚀 빠른 시작

### 필요 환경
- Xilinx Vivado 2020.1 이상
- Nexys 4 Artix-7 FPGA 보드
- USB 케이블 (프로그래밍 및 UART 통신용)
- VGA 모니터 (VGA 프로젝트용)

### 실행 방법
1. Vivado에서 새 프로젝트 생성
2. 해당 모듈의 `src/` 폴더에서 모든 `.v` 파일 추가
3. `constraints/` 폴더의 `.xdc` 파일 추가
4. 메모리 사용 모듈의 경우 `memory/` 폴더의 `.coe` 파일 추가
5. Generate Bitstream 후 보드에 프로그래밍

## 📁 프로젝트 구조

### 01. Basic Stopwatch
- **기능**: Start, Stop, Reset 기능의 7-segment 스톱워치
- **핵심 파일**: `stopwatch_top.v`, `clock_divider.v`, `counter_bcd.v`
- **표시 형식**: MM:SS.CC (분:초.센티초)
- **핀 할당**: BTNC(Start/Stop), BTNU(Reset)
- **학습 포인트**: 클록 분주, BCD 카운터, 7-segment 멀티플렉싱

### 02. Stopwatch with Memory
- **기능**: Block Memory를 활용한 기록 저장 스톱워치
- **핵심 파일**: `stopwatch_top.v`, `watch_counter.v`, `control.v`
- **메모리**: 16 x 32비트 블록 RAM
- **제어**: pause, store, load 기능
- **학습 포인트**: 블록 메모리 인터페이스, 메모리 R/W 제어

![Stopwatch FSM](images/stopwatch_2%20FSM.jpg)

### 03. UART Communication
- **기능**: 키보드, 스위치, 터미널을 통한 UART 통신
- **핵심 파일**: `uart_top.v`, `Rx_module.v`, `Tx_module.v`
- **통신 설정**: 8N1, 9600 bps
- **게임 모듈**: UART 기반 게임 제어 로직 포함
- **학습 포인트**: 시리얼 통신, 보드레이트 생성, 패리티 검사

### 04. VGA Circle Display
- **기능**: VGA를 통한 동그라미 이미지 생성
- **핵심 파일**: `vga_top.v`, `vga_sync.v`, `vga_graphics.v`
- **해상도**: 640x480@60Hz
- **색상**: 12비트 RGB
- **메모리**: Block Memory 기반 이미지 데이터
- **학습 포인트**: VGA 타이밍, 동기화 신호, 픽셀 클록

### 05. Tic-Tac-Toe Game (최종 목표)
- **기능**: VGA + UART를 활용한 틱택토 게임
- **핵심 파일**: `ttt_top.v`, `ttt_ctrl.v`, `uart_controller.v`
- **입력**: UART 키보드 명령 (WASD + Enter/Space)
- **출력**: VGA 디스플레이
- **게임 로직**: 3x3 보드, 승부 판정, 게임 상태 관리
- **학습 포인트**: 복합 시스템 통합, FSM 설계, 실시간 인터랙션

## 🔧 하드웨어 연결 가이드

### 공통 연결
- **전원**: USB 케이블로 FPGA 보드 연결
- **7-segment**: 보드 내장 디스플레이 활용
- **스위치/버튼**: 보드 내장 입력 장치 활용

### VGA 연결 (모듈 4, 5)
- VGA 케이블로 모니터 연결
- RGB 신호: 각 4비트 (총 12비트 컬러)
- 동기화: H-Sync, V-Sync 신호

### UART 연결 (모듈 3, 5)
- USB 케이블을 통한 시리얼 통신
- 터미널 프로그램에서 9600 bps로 설정
- 키보드 입력으로 게임 조작

## 📚 학습 성과
이 프로젝트를 통해 습득한 FPGA 설계 개념:
- **기본 개념**: 클록 도메인, 리셋 신호, 동기/비동기 설계
- **디스플레이**: 7-segment 멀티플렉싱, VGA 타이밍 제어
- **메모리**: Block Memory 인터페이스, COE 파일 활용
- **통신**: UART 프로토콜, 시리얼 통신 구현
- **시스템 통합**: 다중 모듈 연동, 클록 도메인 관리
- **상태 머신**: FSM 설계, 게임 로직 구현

## 🎯 프로젝트 특징
- **단계별 학습**: 간단한 카운터부터 복합 시스템까지
- **모듈화 설계**: 재사용 가능한 컴포넌트 중심
- **실용적 예제**: 실제 사용 가능한 기능 구현
- **완전한 문서화**: 각 단계별 상세 설명 제공

## 🤝 참고사항
- 각 모듈은 독립적으로 실행 가능
- Vivado 버전에 따라 일부 설정이 다를 수 있음
- 보드별 핀 할당은 해당 모듈의 XDC 파일 참조
- 시뮬레이션 테스트벤치는 필요시 추가 구현 권장

## 📞 문의
프로젝트 관련 질문이나 개선사항이 있으면 Issues 탭을 활용해주세요.

## 🏆 성취도
- ✅ 기본 디지털 회로 설계
- ✅ 클록 도메인 관리
- ✅ 메모리 인터페이스 구현
- ✅ 시리얼 통신 프로토콜
- ✅ VGA 디스플레이 제어
- ✅ 복합 시스템 통합 및 게임 구현

이 프로젝트는 FPGA 입문자가 체계적으로 디지털 시스템 설계를 학습할 수 있도록 구성되었으며, 각 단계별로 실무에서 활용 가능한 기술들을 습득할 수 있습니다.