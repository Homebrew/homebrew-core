class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.17.5.tar.gz"
  sha256 "185fc6c05c8c950153bb871ffdad6de47ebf2db18c4607cd4005662d5d9f79b6"
  license "Apache-2.0"

  depends_on "dotnet"
  depends_on "icu4c@76"
  uses_from_macos "zlib"

  def install
    dotnet_os = OS.mac? ? "osx" : "linux"
    dotnet_arch = Hardware::CPU.arm? ? "arm64" : "x64"
    dotnet_os_arch = "#{dotnet_os}-#{dotnet_arch}"

    dotnet = Formula["dotnet"]
    args = %W[
      -c Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(bin)}
      -p:Version=#{version}
      -p:PublishSingleFile=true
    ]

    chdir "src/StateSmith.Cli" do
      system "dotnet", "publish", *args

      libexec.install "./bin/Release/net#{dotnet.version.major_minor}/#{dotnet_os_arch}/publish/StateSmith.Cli"
    end

    (bin/"ss.cli").write_env_script libexec/"StateSmith.Cli", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    if OS.mac?
      # We have to do a different test on mac due to https://github.com/orgs/Homebrew/discussions/5966
      # Confirming that it fails as expected per the formula cookbook
      output = pipe_output("#{bin}/ss.cli --version 2>&1")
      assert_match "UnauthorizedAccessException", output
    else
      assert_match version.to_s, shell_output("#{bin}/ss.cli --version")

      File.write("lightbulb.puml", <<~HERE)
        @startuml lightbulb
        [*] -> Off
        Off -> On : Switch
        On -> Off : Switch
        @enduml
      HERE

      shell_output("#{bin}/ss.cli run --lang=JavaScript --no-ask --no-csx -h -b")
      assert_match version.to_s, File.read(testpath/"lightbulb.js")
    end
  end
end
