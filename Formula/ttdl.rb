class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "c165ea8a74011b31093db8ae9347c4cf9218fde4c98ef124164f66706e0aae85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b1f89a4de96a13900d1e2408b4643bcc192e7d7219c23ae9d5300c3fe26f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d67abd1a1b36355ba975534c3ab6ebcbb6d783910ec880610d3b4b2370fe65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2afb519ca0971988b36da141a43f76df2c6383ebe58e3c9cf4ff5f7245a12869"
    sha256 cellar: :any_skip_relocation, ventura:        "c9134d1cc686564f8423db1a74503ed410db112c5ccf77101b7a0ed3ac0238b6"
    sha256 cellar: :any_skip_relocation, monterey:       "6709b8c2a44a18d625c4bc6e80cc3f4d35c58335a6edc809cfceaac195a86433"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc3b3e3bb17c034858012acdc8b80e526ade02479599cde1c06d9170db02777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87446dfd78c70b2ebe1c725e79b7f3e8239ace2aa76fec311c20b98e2f79b9b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
