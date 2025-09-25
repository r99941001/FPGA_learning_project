import serial

def main():
    # Change COM3 to the COM port your UART adapter uses
    # Baudrate must match your FPGA/device UART setting
    print("start receive data from FPGM")
    ser = serial.Serial(port="COM5", baudrate=115200, timeout=1)

    print(f"Listening on {ser.port} at {ser.baudrate} baud...")

    try:
        while True:
            if ser.in_waiting > 0:  # Check if data is available
                print("have data")
                data_temp = ser.readline()
                print(data_temp)
                data = ser.readline().decode(errors="ignore").strip()
                if data:
                    print(f"Received: {data}")
    except KeyboardInterrupt:
        print("Exiting...")
    finally:
        ser.close()

if __name__ == "__main__":
    main()
