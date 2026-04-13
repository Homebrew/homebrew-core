class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  # Try upgrade to latest `dotnet` on version bump
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.20.0.tar.gz"
  sha256 "be187b4063734694137a95b77928980ad0f61e44e6a4887d07dc7e3387ccfa0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf4441be541137a58c29cb73f53c5baee5b8908a5f1e91f9b179597702afbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c18aa8b4649ede0a69ada9ee81a353b5309602ffd7b6fde815498cfa2c8668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721a893ada168de7cd35a1149cc86fae301ef46c550c850ce1235871a4b26a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d366e58e1954728a52fb5ad6ed2af0d5f185e0677d4d3af3a15f0535cff05067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62691a1e4d14ba928be3c68fd6f3b8b4b68753ccf0c7fb5b248b66804c76837"
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
