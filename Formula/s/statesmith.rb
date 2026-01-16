class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  # Try upgrade to latest `dotnet` on version bump
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.19.0.tar.gz"
  sha256 "62eb44d15a978c82f1ad8a54506f750b76c3dd30ebd1087384366a939a118749"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b58b31d35712d1ec9129d4b79c11b75f2b8a2dfa29b7e0514d21f1af80f4bd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1485ae419ffc50bc791307f3be45f1fd423fef401b3fbc52dc9f38f425d252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de391ced760ccc51cd731eaad848a8cc1a694275ffdd5994b333817f68e727a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d9b709b74a920d0f661df59f163de1c02f073b22efe01bf85b2643eaa50116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1b26d3f0b017dc07473ba5b9020fe2b2da8d558a9d07c69d35e7da357ce8e2"
  end

  depends_on "dotnet@9"

  def install
    dotnet = Formula["dotnet@9"]
    args = %W[
      -c Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/StateSmith.Cli", *args
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
