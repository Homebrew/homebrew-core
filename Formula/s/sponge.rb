class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.69.tar.gz"
  sha256 "0f795d25356ca61544966646fb707d5be0b9864116be0269df5433f62d4e05d1"
  license "GPL-2.0-only"
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    formula "moreutils"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2222a13d620121800f207f8af1b345e1cbf9e771c322e910e4f65b100c5d160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c72b740a203d02fd12bd27949f90e1662fdbbf1c9e19abcde0b66b9d032a9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d216473d739f924c7b973b4aae9f311c481c3412ebe6f0c1d58f46186327e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c308698a3368f0e2182e5a0a0b167222ed57f6bac9a0c28f1e13fc45e254b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "09d8cf8703e517cc9fb003c4ef0b7200a1542a064be631d6da30156cc7f1078f"
    sha256 cellar: :any_skip_relocation, ventura:        "983d686c95825a8fe56952dadf415a6a0dbacacf281d0d0d51669539c5585f41"
    sha256 cellar: :any_skip_relocation, monterey:       "7655e10c757e087426d388b1068a1b6dad16bf36c655bbd9436cff37dddaf816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebabd0385ae159408efc8187938abdba896fa7fbac002d1e2efcdb555f15b87"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
