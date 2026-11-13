class Tunnelite < Formula
  desc "Secure tunneling to local applications"
  homepage "https://tunnelite.com"
  url "https://github.com/cristipufu/tunnelite/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "384af1fbac09b5cda738127b55cd178deb5e43bd7dbb90e7f2e73f458212e726"
  license "MIT"
  revision 1
  head "https://github.com/cristipufu/tunnelite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "385f05239ee2e68b1fb7761733270a7118f7be2d3b3cd8e8d24281c61d2ffa3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb199688b93d47ecfcbaad2d7d44934383458f2a5e02cf06cad30e83e09a697d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d78dd84b3bc1ad4f0b2c86e9a5a3aa2b5b4b475337e7c544a2ac999ed9949735"
    sha256 cellar: :any,                 arm64_linux:       "1ce8d713e7febf6fc88f106c2fbb268017edf09fd1d8c696aba235ff61324ed2"
    sha256 cellar: :any,                 x86_64_linux:      "5911cab9ee7d0db3616ec9fd865c6488061b5e658752f68d5eae2609c0075410"
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
