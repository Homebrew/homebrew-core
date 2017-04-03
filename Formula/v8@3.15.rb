class V8AT315 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8-git-mirror/archive/3.15.11.18.tar.gz"
  sha256 "93a4945a550e5718d474113d9769a3c010ba21e3764df8f22932903cd106314d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e3fbc94e5599418c351359a77c335beab824e99ebe8006379e97097694a18607" => :el_capitan
    sha256 "a540a1bb558076d45666623814645c5b1f03c96dee0b0a21d02c63f68fdee8a1" => :yosemite
    sha256 "33b48defef5c8e5f39c6bf20b0f85f6488c4e8282a9d5be38746907f035c4723" => :mavericks
  end

  keg_only :versioned_formula

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "f7bc250ccc4d619a1cf238db87e5979f89ff36d7"
  end

  def install
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
