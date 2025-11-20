class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.19.0.tar.gz"
  sha256 "62eb44d15a978c82f1ad8a54506f750b76c3dd30ebd1087384366a939a118749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9c19f657fbff70ad690d5b0910ab9b55559514f24f76661f078799f823f1a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69698d4830609f132f6f2bf03c6e13edce217ba58635c41d3f52c895c5c47a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adfb4d4c32dda160755d4b1fe8f1e8d88398bd62e3de1242d4dcd78e6f89da27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1398645c8a9cbbeb2208b4e01c0dfb168ff730360db333d4036eb2f9940d744"
    sha256 cellar: :any_skip_relocation, ventura:       "a346a06beaaafeaf662489a7a43be53d31b27c2c15912c7ed8fb9308eb0f363b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4232fb5b9e94609e742f695ff84d017cda14765b89448d87c4a8e62fbc04696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80deb05098101d193abbaa92c8113e7a7cb150dcbaecaccd58c4bc2f3836912"
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
