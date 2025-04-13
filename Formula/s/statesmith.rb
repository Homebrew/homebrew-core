class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.17.5.tar.gz"
  sha256 "185fc6c05c8c950153bb871ffdad6de47ebf2db18c4607cd4005662d5d9f79b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a75aa770bfbe5736191b850192f3018d60de182fb55dbb3a84dba2b4a7c90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "926fafa1d15bcca00d6372824d26c6bbd55a59b0a6cf5cf34ec338c7462321e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a11d4baa36bad4b9781afeda8e6767a5e6883e800cfbda179755c41f0344f13"
    sha256 cellar: :any_skip_relocation, ventura:       "0a52242c5fc55c753a125e12de944672d59ca660c5f7852b7e8809996380b0b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea33392880ca8706e3013cd7d491be55f24ac755a0f0907956d07932937cf37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cccfa195619b84f8094ad0a86f8b6ec9b6f11d6c137bbedca6e7f10d06c3c2c"
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
