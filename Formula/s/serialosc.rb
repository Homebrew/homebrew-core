class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.6",
      revision: "82982437ba197b93793e89eee1cbb12c1f73e928"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88048b5ee792c6b2b31ad617c6e5289ae2238b6ae9370b9b7a4774291c4cd015"
    sha256 cellar: :any,                 arm64_sequoia: "6bf7e4ce2c236c488e3d5f5779f97d888f19c471aaf0d08e9fdefea7afea20c2"
    sha256 cellar: :any,                 arm64_sonoma:  "498514d0881e192dd36837716da1df5a7256179f515dc8b1dace4f480348b724"
    sha256 cellar: :any,                 arm64_ventura: "9e549647a50621a2bafce9aad05daef120e36767af5e57a3df117d6afc5c580e"
    sha256 cellar: :any,                 sonoma:        "4bda1903d28760b7b340db427ebf78566a93171f494ea082cd63d6eef79b0e23"
    sha256 cellar: :any,                 ventura:       "d2cf788f4bf6dd3805af4f729e9dc7ed7a1ecde36a93468014a20052dddb87fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd3d5d496535917f6e503b7b4041e23ea50b33a99c695f0ab68abcdbe576ace2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4eee0e4d13807fb31e5ccb13536357177f2285f546af6ee9bc167a778797323"
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi"
    depends_on "systemd" # for libudev
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
