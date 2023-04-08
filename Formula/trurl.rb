class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.3.tar.gz"
  sha256 "708d3bb95463ae160765d4197bbab3a708f9356f70ea9d1334840fdd4f5796eb"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da6668f46fff34bb0e837b419abf8b40d77cb853c8efc529780110fc0ceebe3"
    sha256 cellar: :any,                 arm64_monterey: "c5f59854389d34fdf5ab6f64b8d7207d955937de962254ddb4dc7685ff214d11"
    sha256 cellar: :any,                 arm64_big_sur:  "7715e95c67b5565ef00be9da7386607ddac2a30ccdb4554fe6c52e9e419555cf"
    sha256 cellar: :any_skip_relocation, ventura:        "d49842fc9f9080f170f0ab0fe95981fdadc44b3e1629d897606ce6c395165ee3"
    sha256 cellar: :any,                 monterey:       "0976a3a9468a5000d9e5b53068efc194be986bb04ccf1aae6fd4c862667ca655"
    sha256 cellar: :any,                 big_sur:        "274655e46d052584dc0ede79e1bb6bada373fbcbe0140c7cc1d16b4b2588ecf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb4fb3d41bec0dc105e15702e4f10f9c95a18748ee327cb220d301037b11442"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  on_system :linux, macos: :monterey_or_older do
    depends_on "curl" => [:build, ">= 7.81.0"]
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "https 443 /hello.html",
      shell_output("#{bin}/trurl https://example.com/hello.html --get '{scheme} {port} {path}'").chomp
  end
end
