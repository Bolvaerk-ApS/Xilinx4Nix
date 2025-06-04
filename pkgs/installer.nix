{
  requireFile,
  runCommand,
}:
runCommand "FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001" {
  src = requireFile {
    name = "FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001.tar";
    url = "https://www.xilinx.com/support/download.html";
    hash = "sha256-l0+S90m9FeOMRdhwfEWznvkDgZMQ3Blryq+2brFsjzw=";
  };
}
''
  mkdir -p "$out"
  tar -xf "$src" -C "$out"
''
