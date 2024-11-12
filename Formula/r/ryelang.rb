class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "ed3414866c6061628b6a0a928722a25a9703aa34fe73c73c3f0b4614aa7c612a"
  license "Apache-2.0"
  head "https://github.com/refaktor/rye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b1141d3842e28f41dfcb7db3e1be364526970f939265c6fabd427af40deab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7250821b862b9de318e0184ec379ddb6cf7c568446e349f9a8c2da18716dfa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06500afb25333d7d95ec1bc631815ab5fd98e51b5d0d62e7ecc8ce366d3b3f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "51028f6d219b369c1220f9041073e8aa0c09556fa1aac0996995fe41bfbb9055"
    sha256 cellar: :any_skip_relocation, ventura:       "5451f0f7f8017f6e83756ee68ed8558723c942ed55072b598b5d51e3ce213c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29bd1fd25f060102bd229075e5c8de1d9e71d8bab77f5f6106c16a7a51fb5b4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
