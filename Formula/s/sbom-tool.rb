class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "aa7548ff0720a375984b25cddac4a8e252f85b9523a7a357ab20c3d282a5bb92"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8a51b520982ed9854d57b2d8fc7107b271c9844c74c111ce18d9aa037bbb8e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a51b520982ed9854d57b2d8fc7107b271c9844c74c111ce18d9aa037bbb8e1"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb07e840d9d97ba07aceddcf346bf02222b098bfaf56a9c3c9df15cd361e5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb07e840d9d97ba07aceddcf346bf02222b098bfaf56a9c3c9df15cd361e5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6be797b74091c3a50ed591ab57b7a723381d9b299245b1368d35cc54f29371f"
  end

  depends_on "dotnet" => :build

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  # patch to use mono.unix to support arm builds
  # upstream PR ref, https://github.com/microsoft/sbom-tool/pull/409
  patch do
    url "https://github.com/microsoft/sbom-tool/commit/dd411c551220fbb579e58c4464b284d2a6781080.patch?full_index=1"
    sha256 "d99878256a1ce470d0f424c86215ab07c5381cc29ee83c90129166899057a6fb"
  end

  def install
    bin.mkdir

    dotnet_version = Formula["dotnet"].version.to_s
    inreplace "./global.json", "7.0.400", dotnet_version

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --output #{buildpath}
      --runtime #{os}-#{arch}
      --self-contained=true
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    bin.install "Microsoft.Sbom.Tool" => "sbom-tool"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
