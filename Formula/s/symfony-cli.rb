class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.23.0.tar.gz"
  sha256 "649e6a9583c5c6456eada1ca8102e9cbe00a6b8d66ff5bfe5e5c89fd370172a5"
  license "AGPL-3.0-or-later"

  bottle do
    manifest_sha256 "19cf2a84894bc465826a5a765aba08b6a22f891a77b28e4dd786d5fff3c4af24"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53674a63a7ca5ffd661d3ed2b8521f66b2669a57af6e632e8510607955726e76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb25316b26b40337fbcb3c4f5a6bc47883e285edc3f141c19fd7c0a5dd79102b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecc750fcffbfc5ec0319435129c9f904ecafcfd8006cc480aeb1b819736dc156"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1be9f3b7fe0eb1b6dea4376f074d208247c7e165ee4184f103028dd2791cb25"
    sha256 cellar: :any,                 x86_64_linux:      "303e75b97b1975f98278e50322d0d45cb9a0f1f4307638160870a0f7d48e0a15"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
