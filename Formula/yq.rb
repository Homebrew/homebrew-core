class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/1.15.0.tar.gz"
  sha256 "f8eb713178720008744a68bcb5c9563cbe4674a579d5d46018797bc917ccca26"

  bottle do
    cellar :any_skip_relocation
    sha256 "5736dbc4b1604a09c3a2549f82691028b46435b8577f78f59c058542bb15d6ef" => :high_sierra
    sha256 "bd42cc8550a7c819e36122a1a96fbf0352c177686b80779e5eebcdc05fa91869" => :sierra
    sha256 "0166dece9855475db41dc331fdff1b06892298e4609c3382bb122c805818375d" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
