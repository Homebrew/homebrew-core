class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.17.4.tar.gz"
  sha256 "a4f86dcd9a1e59042f20e134e61f2af87534065ceb0a204f70b20e62eef1ab22"
  license "Apache-2.0"

  depends_on "dotnet" => :build
  depends_on "icu4c@76"
  uses_from_macos "zlib"

  def install
    dotnet_os = OS.mac? ? "osx" : "linux"
    dotnet_arch = Hardware::CPU.arm? ? "arm64" : "x64"
    dotnet_os_arch = "#{dotnet_os}-#{dotnet_arch}"

    # Make sure the version number in the built binary matches the tag
    system "sed", "-i.bak", "s#<Version>.*</Version>#<Version>#{version}</Version>#", "src/StateSmith/StateSmith.csproj", "src/StateSmith.Cli/StateSmith.Cli.csproj"

    chdir "src/StateSmith.Cli" do
      # Why single file? https://github.com/Homebrew/homebrew-core/pull/207657#discussion_r1965759965
      system "dotnet", "publish", "-c", "Release", "-p:PublishSingleFile=true", "--self-contained",
          "--framework", "net8.0", "/p:DefineConstants=SS_SINGLE_FILE_APPLICATION"
      bin.install "./bin/Release/net8.0/#{dotnet_os_arch}/publish/StateSmith.Cli" => "ss.cli"
    end
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
