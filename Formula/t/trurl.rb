class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.9.tar.gz"
  sha256 "848da38c0ea07cd96d6adac4a5e5e141fe26e5bd846039aa350c3ca589a948e0"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c26366d7499505bd45a630f3fca353dbb085db703a0dcc5c02b216224218289"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da4fe1f03660e5738eeae227ee8baeaa91a30578a0b4894e1cec3a6f51c64017"
    sha256 cellar: :any,                 arm64_monterey: "317d8422c5e8e4968e9bb642086f803a919069f021fcc2eacf6daa8dc09f5f42"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc8a38b80566c733696438c2fcc024d0d67c851aebde0be748bf5aac7eada34"
    sha256 cellar: :any_skip_relocation, ventura:        "02d4e684b4995c8ab307ee473dd09e69de7ae3ff4e4e6a9a4de77c0fb07a4caa"
    sha256 cellar: :any,                 monterey:       "58031b3af7bba75daa757392b93be7a504c304a8db1fc5996df3dc7923f9a067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c08e26190d7b6491d3258187cc7db30ca7e66aa9dd04d10dc37668fa9fb98b"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output(bin/"trurl https://example.com/hello.html " \
                              "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end
