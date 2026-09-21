class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "1ea41f7d06b0017fe3d3ba7ee30959048aa0ddde31cb0165dab9257edf673321"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a01a67705f5642ecc2e9d0509d2e416ba6482493dd071e4c4536088bff9bb67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aadb87c9f1a6863aa22e2881383b9d1747e2916fa130d561ecaace2adfbfe9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "984e02d8826b70a43973b38b7cec2775039dc10752826167055b83b07fed083b"
    sha256 cellar: :any,                 arm64_linux:       "b21480f780fdaced8995f3fcf60496e65990cde77a3e6378d1a6773a7497eafe"
    sha256 cellar: :any,                 x86_64_linux:      "7b8482e78356397d13f5f837fa5c0253f4b9369483dc15c61dff83b52414dffe"
  end

  # TODO: unpin go@1.26 when sing-box supports go 1.27
  # ref: https://github.com/SagerNet/sing-box/pull/4182
  depends_on "go@1.26" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build # extract_histograms.py fails with macOS python

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  on_linux do
    depends_on "lld" => :build
  end

  resource "cronet-go" do
    # Using git checkout for submodules
    url "https://github.com/sagernet/cronet-go.git",
        revision: "0d28acc44093df24b2526dea3d6ffefd6b0a54f0"
    version "0d28acc44093df24b2526dea3d6ffefd6b0a54f0"

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
        revision: "3357c4f51b1a9e676378c695dd9c7e9911c35ee6"
    version "3357c4f51b1a9e676378c695dd9c7e9911c35ee6"

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
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end
