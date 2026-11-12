class Tunnelite < Formula
  desc "Secure tunneling to local applications"
  homepage "https://tunnelite.com"
  url "https://github.com/cristipufu/tunnelite/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "384af1fbac09b5cda738127b55cd178deb5e43bd7dbb90e7f2e73f458212e726"
  license "MIT"
  revision 1
  head "https://github.com/cristipufu/tunnelite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b126dc90c30463d364f91736b88446df87aa9d9b02a00cf2a445ac70e063112e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a18badf65cd39aba46dc0499aa79ea6a03e30a52119fa41e9dd7b53869de48b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c628cf1689732558ff2f85b1cba48e1a9bb83e5702be897d34a1bce66dff0c8d"
    sha256 cellar: :any,                 arm64_linux:       "b2990d86ac84a8016d7d81678d4e1c39d02aa62d9f18612fde7829500d5faf0c"
    sha256 cellar: :any,                 x86_64_linux:      "61bedc654efca0804d5d00bdbd468dbab10eca300174389ddd3b2d7bafe7e69e"
  end

  depends_on "dotnet@10"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula
    # Force a single MSBuild node: worker-node sockets are denied by the macOS sandbox (Homebrew/brew#23920)
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{bin}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(bin)}
      -p:DebugType=None
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/Tunnelite.Client/Tunnelite.Client.csproj", *args
    # Rename to match https://github.com/cristipufu/tunnelite/blob/master/.github/workflows/release.yml
    mv bin/"Tunnelite.Client", bin/"tunnelite"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/tunnelite --version")
    shell_output("#{bin}/tunnelite ftp://localhost:1 2>&1", 1)
  end
end
