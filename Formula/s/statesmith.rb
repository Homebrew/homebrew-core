class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.18.2.tar.gz"
  sha256 "f6823b7734b431bd567a59258549b3a77662d1b561dc33093ea503f904be25ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f698f5d2d76c8eb1f778e499ea4e557a6279992bdb974311b1231853fef6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7542a876bf8a924ce082cc0de8a1f7fe5e6b3c9660340a6cf7cd0d446371bdeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eff01365f5cca9d476f49b3833ff71be77bbcd16e7b57795a3410f806af8be26"
    sha256 cellar: :any_skip_relocation, ventura:       "e18105ffcabae10501200f28a10b641afca02bb924b75ea22d1e44faf2474cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0d47885851de435d1ec58e52e5c7493ab5fcc1158bc973ebdb9119c68f17aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43fb000e7287ae4ae3b6fe53a88024f7d81ec1d35955975fb7ce01997f241ca7"
  end

  depends_on "dotnet"
  depends_on "icu4c@77"
  uses_from_macos "zlib"

  def install
    dotnet = Formula["dotnet"]
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
