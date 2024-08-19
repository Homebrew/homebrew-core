class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "636bccb8b5a18b709f735f29979e53752f3d71e1c246b7ce845d802766937bf2"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efaf677e10be0712b55d5ecaa52d051d28a86042d8a3acd1461422604d32f43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5648f025089584199f224c175687e4df53cfa1277ce0739de7ca4709c37344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c6357c4aa97ac5bc6c653fb3677c44af1b7420ff6249173220abb57db29b2c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "61cfaf4f2557aea241ab54cf3a084d8a672def4e6fbc8e6571742747c0705a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "d2f308d9d78009e06dd4329dc68acb2ffd8a4e0ec34328a3e882e50a1354c12b"
    sha256 cellar: :any_skip_relocation, monterey:       "807fdb2b92e0e61aa94698c09c35113b79972d73111521effa4f4633597e1e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c890b75d2c4ad273867b4fb1206cfe620a49c0c666f1b491adf92e4a03243b"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_predicate testpath/"Library/Application Support/subfinder/config.yaml", :exist?
      assert_predicate testpath/"Library/Application Support/subfinder/provider-config.yaml", :exist?
    else
      assert_predicate testpath/".config/subfinder/config.yaml", :exist?
      assert_predicate testpath/".config/subfinder/provider-config.yaml", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
