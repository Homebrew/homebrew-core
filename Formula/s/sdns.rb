class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "26885f54c6fc725bbf55a34f9f1b68f105d536029b0d9cb50c997a3758067248"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f4e8cf7ad0f8126889e9454d3b42ee6ac48c48a0ca365525e0c679380aad65c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc0181eb8458055aaf241473a6abce91538e40406127a7a34ee323ad3791f7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1f530cb6776ad1c1ba79e1f29c15eab68424247fcc765fe094fe10bccf120bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "90bcebbe2792262a1cc6a708f91c17580af97e8522fa90e9af39c4638047dd9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2655dc9022fe83d753596df57725d4649233bfadd709e09f36ddc6ef05e099b4"
    sha256 cellar: :any,                 x86_64_linux:      "9511462bcab80c71009e3f1acfa86638e23c51230c1c4b268cd2b88c0c9971e0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    require "open3"
    stdout, = Open3.capture3(bin/"sdns", "--config", testpath/"sdns.conf", "--test")
    assert_match "Default config file generated", stdout
    assert_path_exists testpath/"sdns.conf"
  end
end
