class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "714649906f533b5948eeaa5027dbe284789039b818d2a034ce47ed67953e95c4"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5a755bd5f06e480aa88f936ea46e81688cc4ea25776d71b1718fa54dd3fc032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3057a6d0243fc0c6e7712aa4a110eaff53a8fbacd846479c4491a0ccebe3282c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eead1297d013e9582621eba4f7987ead1f602b22e25d596f039ae2f2fd38fad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a66ac1e8285897ba49da131b01236515adc87a82b0ede48025c73fecdc89ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d0e1e42d13724183619807395b0f9d668590066fb4b76d2dcd2709e44cc2c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685ea79eb23417b8ae38f78e6ea36706e41a76b7b60fd752844c4deaf524b941"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/projectdiscovery/subfinder/pull/1669
  patch do
    url "https://github.com/projectdiscovery/subfinder/commit/dfcd02d5baf865ef6b6eeccfcf0df01ddaae60a4.patch?full_index=1"
    sha256 "b3a79b83e8cd5df72a82b59a46e893679a05458d1fe98236a6df1860d4c25506"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/subfinder/config.yaml"
      assert_path_exists testpath/"Library/Application Support/subfinder/provider-config.yaml"
    else
      assert_path_exists testpath/".config/subfinder/config.yaml"
      assert_path_exists testpath/".config/subfinder/provider-config.yaml"
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
