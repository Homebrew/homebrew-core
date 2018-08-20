class V8AT315 < Formula
  desc "Google's open source JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8-git-mirror/archive/3.15.11.18.tar.gz"
  sha256 "93a4945a550e5718d474113d9769a3c010ba21e3764df8f22932903cd106314d"
  revision 1

  bottle do
    cellar :any
    sha256 "38ef56c652ac4f91ec1ddac61b8719ffba4c949103a6636e15aa1cd768e2d14d" => :mojave
    sha256 "42c0c3b3f4dc7153023e14aef59c623f10c78ffe8f2d7a43ab984f2810a694dd" => :high_sierra
    sha256 "4b845ce6a7fdc4110518dfbf48ab721d7f48b9e64f78e6d1cc199078ac9d874b" => :sierra
    sha256 "9c191175be793dba50999f5ac1894f26b9eb39ca231f0618d5954833e5db8945" => :el_capitan
    sha256 "f3b4dddabc17df3d84c3e1bbd894fa33a60e221a150eb7ede77d64daaef1088b" => :yosemite
  end

  keg_only :versioned_formula

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "f7bc250ccc4d619a1cf238db87e5979f89ff36d7"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    (buildpath/"build/gyp").install resource("gyp")

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    system "make", "native",
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install "include"
    cd "out/native" do
      lib.install Dir["lib*"]
      bin.install "d8", "lineprocessor", "mksnapshot", "preparser", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
