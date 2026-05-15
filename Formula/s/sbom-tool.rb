class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "512d884ce8689026f45b54a1c2a242e66f7d570e7d9a1a590d88733cc3e1a108"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b6f4918958ec0e7e70ccbb235644379bd18ff47afe57caf7d8c1c8cbedef67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab14eebe6248adcbb8a0bf171222131c57c0841ead2d19872d67d58e4191aa5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083d6b8c50c9c6999d8ccdaf0facf81e25b58287d8a047c372e6a517d8ad1bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6613476c7a9046af605b796661736ce125b23ac0a01cf400920d99d095d9796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee862f5f6b5c288e44ae1be6f39976b76e7a52a3c5c1cbcae09a076822d4ff5"
  end

  depends_on "dotnet@8"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb https://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
