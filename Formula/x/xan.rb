class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.49.2.tar.gz"
  sha256 "1d63e6abe21715fc8e053c5fc6ea3d4862d039443a736de558f47e11435de738"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ef0c0a8b95c7fada4411043d1d21ed217dc068800954af03a5f72ec32137d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46da503894ae9a9f233d8b093e2eaff957dde9a54e51edefdb32048153e962b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f17a6ae0ed53974a7ce17660d5ec8cda9a26faae416b331431c842f645b4b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf0d00afd38f1ae6b96b1b55ed7186e4ec7010a2b6db900c7551bbf2b8c4cfe"
    sha256 cellar: :any_skip_relocation, ventura:       "4e0b1b663b572d01fd48ff239a70454504d0a50a6ca0a2691362e2331f37ed05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2df45521025e1ffc20213e3e77866b082d3bf681ec175136a6eaa496a57a1f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a26c7e896136796e590a5ebb813eb2e1985e227c392309856296cd5255c715fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
