class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  # Try upgrade to latest `dotnet` on version bump
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "2001391ebd2a9cd9b4ee9a88ba662f736547a0e7d8a9b43f30c8cbec4eac2e36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eca6c6515c34c384f38aba48ebf44e9b7650cc8b19317997686373bcbd6c047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce2e978401b34b8e2e51af99142555b142789399cf5032a5b30e463308c4c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f78e984837628c05fda50fc96482d6ee4e6df2b160466678a453bcfff3d3f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b1736097256e2948122af1e65072afb9c09233c03ea15d2a8ab99169d211c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e0f249d28ccf3faa4e8dc6c2d9c1d6f550a7cd52fb20b7ff8bea0ea3bd4b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c54a48c9fdfa149e96133eb558d55e0921555e1eb9527dbea3e9d3233f5bd6f"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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
