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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c31aad15124b2f83da7a0ed010a2716e9aedf4bc851d59693111bb23b2393bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d1227a118a8789126adca3b5cf9c8b13e44d7024853929570161d26cd019929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "976cfb7dd806d4171e91e5940ea94c3f5210e756bb327858446550fcffc4bade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c682d73f2274bc7f6d54c81d7e47ad00ac384a54d166d5a297a8b209aa6ae2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1d920bb9f3bdcbc323879069b0e2027ac898c4ccdb2c336ac1f97e99afa1e4"
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
