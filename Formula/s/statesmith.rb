class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.18.3.tar.gz"
  sha256 "8f7d72d6d5624ab60617ec668ac617e10842ddb559013e49d345174ea5f0a4ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51a2b7d29a819b61412f6e61375be281913b70969124bc1b38e556d99f99a7e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4067416e009ceca48dadfa14747ed906c8aebf9f5830fbc0f2d9cd0cf5596734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388d77f0ca4451a2f8a7a7745475bb379a653e11eb7ef59fa10b540c924d1e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "d5801e45af1dec109276a130a924a83ab3c3d22af8ab650432267e4e3ea574f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96bdc03ac76d9856ebfffb850efb386f01b7b638b93797aa68db7c881e077b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2490c6fbc709c4e303a0db64b6fc9d2a50db753116e8434dd6a333e610872c6"
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
