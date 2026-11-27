class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "d7d5a6f64c213958cb2a11b82cfaa6c7acc0a877a28033193c8b3949a45c3646"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    manifest_sha256 "d4f70dd17cb9ca5d323489f1a57af79bc7575d20017df256b4094855fe50af3d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2155172abf27c47669162d0d82e82bf2c28e48d6e6da640f38e1c31920ff1570"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e001a4d995f5ede5e5af3661562d924942b1d3c94c6fe832039bfe08463d4d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f847bbf3a6b8a348f0ed940349b1ffd172c4a2f52c14e1df7e69e9b83f05b91"
    sha256 cellar: :any,                 arm64_linux:       "d4e6bf0ff9c28cfe49a409193952cc0e4604ba590cc1a7fe7f3afb8810c7c5e3"
    sha256 cellar: :any,                 x86_64_linux:      "b8fc608a8691be81122301384568b86ccd9aa9ef7dda40bbc1c68021216f9833"
  end

  # TODO: unpin go@1.26 when sing-box supports go 1.27
  # ref: https://github.com/SagerNet/sing-box/pull/4182
  depends_on "go@1.26" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.15" => :build # extract_histograms.py fails with macOS python

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  on_linux do
    depends_on "lld" => :build
  end

  resource "cronet-go" do
    # Using git checkout for submodules
    url "https://github.com/sagernet/cronet-go.git",
        revision: "ccefd17767e7b91299e0d54a6b1bb0468cf9173f"
    version "ccefd17767e7b91299e0d54a6b1bb0468cf9173f"

    livecheck do
      url "https://raw.githubusercontent.com/SagerNet/sing-box/v#{LATEST_VERSION}/.github/CRONET_GO_VERSION"
      regex(/^\h+$/i)
    end

    # Avoid downloading pre-built Clang. Based on Arch Linux patch, which is based on nixpkgs patch
    # https://gitlab.archlinux.org/archlinux/packaging/packages/sing-box/-/blob/main/0001-build-use-the-system-toolchain.patch
    # Also disable lld on macOS for similar linking failures as V8 formula.
    patch do
      file "Patches/sing-box/cronet-go.diff"
      type :unofficial
    end
  end

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "150a9d6ba0aa7f407aa4feeabc5f03ce9aa7e04b"
    version "150a9d6ba0aa7f407aa4feeabc5f03ce9aa7e04b"

    livecheck do
      url "https://raw.githubusercontent.com/SagerNet/sing-box/v#{LATEST_VERSION}/.github/CRONET_GO_VERSION"
      regex(/["']gn_version["']:\s*["']git_revision:(\h+)["']/i)
      strategy :page_match do |page, regex|
        cronet_go_version = page[/^\h+$/i]
        next if cronet_go_version.blank?

        cronet_go_url = "https://api.github.com/repos/sagernet/cronet-go/contents/naiveproxy?ref=#{cronet_go_version}"
        naiveproxy_submodule = Homebrew::Livecheck::Strategy.page_content(cronet_go_url)[:content]
        next if naiveproxy_submodule.blank?

        naiveproxy_commit = JSON.parse(naiveproxy_submodule)["sha"]
        deps_url = "https://raw.githubusercontent.com/SagerNet/naiveproxy/#{naiveproxy_commit}/src/DEPS"
        deps_page = Homebrew::Livecheck::Strategy.page_content(deps_url)[:content]
        next if deps_page.blank?

        deps_page.scan(regex).flatten
      end
    end
  end

  allow_network_access! :build

  def install
    resource("cronet-go").stage("cronet-go")
    resource("gn").stage("cronet-go/naiveproxy/src/gn")

    # Source build libcronet.a and replace cronet-go to use it
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    target = "#{OS.kernel_name.downcase}/#{arch}"
    libdir = "lib/#{target.tr("/", "_")}"
    cd "cronet-go/naiveproxy/src/gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    cd "cronet-go" do
      system "go", "run", "./cmd/build-naive", "--target=#{target}", "build"
      system "go", "run", "./cmd/build-naive", "--target=#{target}", "package"
    end
    system "go", "mod", "edit", "-replace", "github.com/sagernet/cronet-go=./cronet-go"
    system "go", "mod", "edit", "-replace", "github.com/sagernet/cronet-go/#{libdir}=./cronet-go/#{libdir}"

    if OS.linux?
      # CGO is needed for cronet-go to link libcronet.a
      ENV["CGO_ENABLED"] = "1"
      ENV.append "CGO_LDFLAGS", "-fuse-ld=lld"
    end

    tags = File.read("release/DEFAULT_BUILD_TAGS").strip.split(",")
    ldflags_shared = File.read("release/LDFLAGS").strip
    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version} #{ldflags_shared} -buildid="
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    rules = [{ "domain" => "example.com", "ip_cidr" => "192.0.2.0/24" }]
    (testpath/"rules.json").write JSON.generate({ "version" => 2, "rules" => rules })

    system bin/"sing-box", "rule-set", "compile", "rules.json", "--output", "rules.srs"
    assert_equal "SRS", (testpath/"rules.srs").binread(3)
    system bin/"sing-box", "rule-set", "decompile", "rules.srs", "--output", "roundtrip.json"
    assert_equal rules, JSON.parse((testpath/"roundtrip.json").read)["rules"]
  end
end
