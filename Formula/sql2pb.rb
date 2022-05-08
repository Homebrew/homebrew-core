class Sql2pb < Formula
  desc "Generates a protobuf file from your mysql database"
  homepage "https://github.com/Mikaelemmmm/sql2pb"
  url "https://github.com/Mikaelemmmm/sql2pb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "9ed48666f7863589246c0dad4f8b95f7ed093304f1f60d0e127e37ca7b12363b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sql2pb"
  end


  test do
    true
  end
end
