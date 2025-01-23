class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "c717e54798e21356340271e32e43de5b05ba064ae64edf639fede27b1ed15ceb"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa383868378793d6b2e0c857db17029a4bf8349bc597aea9fef482f150b44cf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b00670462d88554d12552f1d5cadd9e7a50f2c554a748caf72207554f963a5ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cca8c7f173c82a878f710b1e561faf96f789b3f364879c34a1b219dcef09cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafd23514a8391cd619b466bf3b20ed583bcafca6ad6eb4b100b98dbf4bba7fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "844c2133809440e5564902c5540ce23bb29182591bada43290ff71c3ece2c04a"
    sha256 cellar: :any_skip_relocation, ventura:        "8be1e9706e82d20f44c8be658e534d51f5edccb365f05798aa2edc4058aaacae"
    sha256 cellar: :any_skip_relocation, monterey:       "5214c329e436a930c654e9c060c178bb8eb1a818472e232e220cee63a68c4857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a9b810e1e7edf4e84b7404e60849777d016ab18fb7deba2ae46c047541a2d8"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}/sad -k 'a' 'test' > /dev/null"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}/sad --version")
  end
end
