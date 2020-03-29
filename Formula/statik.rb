class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.23.0.tar.gz"
  sha256 "6159066f486811e5773da318d6e8d1b1dd4c99ac140f1a3c660ef1c1f5e7124f"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any
    sha256 "28905bc1096c08ebe04410557de4b7a0c1c6ef4b016d5ef636cf04a37313bc11" => :catalina
    sha256 "88b425b5e8fdb8f42bebed953096761034d21a6da5511be73384fd11a14c6d1b" => :mojave
    sha256 "45fa0c5eb8cc013f7637d0f319c3c2a7d19e2360572fcda47fd1873157d77b74" => :high_sierra
  end

  depends_on "libpq"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  conflicts_with "go-statik", :because => "both install `statik` binaries"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "statik"
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"config.yml").write <<~EOS
      project-name: Homebrew Test
      base-path: /
    EOS
    (testpath/"models/Post.yml").write("title: String")
    (testpath/"data/Post/test-post1.yml").write("title: Test post 1")
    (testpath/"data/Post/test-post2.yml").write("title: Test post 2")
    (testpath/"views/posts.yml").write <<~EOS
      path:
        template: /{{ post.pk }}/
        for-each:
          post: session.query(Post).all()
      template: post
    EOS
    (testpath/"views/home.yml").write <<~EOS
      path: /
      template: home
    EOS
    (testpath/"templates/home.html").write <<~EOS
      <html>
      <head><title>Home</title></head>
      <body>Hello world!</body>
      </html>
    EOS
    (testpath/"templates/post.html").write <<~EOS
      <html>
      <head><title>Post</title></head>
      <body>{{ post.title }}</body>
      </html>
    EOS
    system bin/"statik"

    assert_predicate testpath/"public/index.html", :exist?, "home view was not correctly generated!"
    assert_predicate testpath/"public/test-post1/index.html", :exist?, "test-post1 was not correctly generated!"
    assert_predicate testpath/"public/test-post2/index.html", :exist?, "test-post2 was not correctly generated!"
  end
end
