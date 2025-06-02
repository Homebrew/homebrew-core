class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "5395100f4516eb7c02a7833fcb3683a2d14282ac4eaa4d04b59482d8717a82b8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091a534b4ace588d7398271aa41dada17d506a72171978000890b2a8ed195019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4040221ef75fde3146d997bb4d83f3b809ae5b4aa55edd490e74e7329f7ca30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f12c0fc73af505c4b63b02f53e95ad916aa88e9983762866fdc018640d987ab4"
    sha256 cellar: :any_skip_relocation, ventura:       "6a3f293f560fdf2d611c34675ae4b723c711174509a46f0912fea345f56dbeb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb0265f4fae02ca7955842636cb893d224c4fed84002866c4dd8a83ea1c5cde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645ef4079653a651249ed7be05ba7fc7c3946ac41245c98c0badbfbf35693dca"
  end

  depends_on "dotnet@8"

  uses_from_macos "zlib"

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
