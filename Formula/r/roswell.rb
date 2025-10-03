class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/refs/tags/v24.10.115.tar.gz"
  sha256 "9c23cb263d4645caaae21cda8f1f5793b0f08ee5c5338aab5974cb4f473d1c4b"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "609cf8897c3fc361cd9d09404b20ecf46f426625f17f0549c1b6db755fde9129"
    sha256 arm64_sequoia: "aba14ed969bb0a51b5a0e6d2e88e38e7fab528d5f97cc2e5eef13685287f7a35"
    sha256 arm64_sonoma:  "6fe9684d8976b196444abb760c8c2efcdf270be7a8049a85eec0783c6d306b14"
    sha256 arm64_ventura: "2d4fea24b4c5de40377044a3291b4e9c52726471429ccfa7e1d5cb947c469e9a"
    sha256 sonoma:        "3a5d20abf0c25e826d79e3b8aa6590e7a3bc4357b382d60bd989cdfa2ec32768"
    sha256 ventura:       "ed5e9df8bb6046e88d6a2dd3cfa3d21cdbbdda109a36b6f29c8cf08f56a5d0c6"
    sha256 arm64_linux:   "53775b6576486eb4ed0a7fa0145f85795791ceeb2ebe7182006068d8039f4039"
    sha256 x86_64_linux:  "86f21b721166645b445f0419c8a8c5b91ee22202e6ec3b9cf620266a93d588d7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_path_exists testpath/"config"
  end
end
