class Szl < Formula
  desc "Compiler and runtime for the Sawzall language"
  homepage "https://code.google.com/archive/p/szl/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/szl/szl-1.0.tar.gz"
  sha256 "af5c647276fd0dea658eae6016957b7ad09ac68efe13ae2a3c867043b5889f87"
  revision 9

  bottle do
    cellar :any
    sha256 "0589a4de79868fed202efa47750154a236763bcb0e49597cbf524a36db01ae8d" => :el_capitan
    sha256 "32fbf94eab483b16311c9d12640d51aeafd7c28898d53437b40ff5759d192f98" => :yosemite
    sha256 "44060a3952401c38c46b7d4cdb22d975cff21b1bbf999a651f45034ab74f7f6f" => :mavericks
  end

  depends_on :macos => :mavericks

  depends_on "binutils" # For objdump
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "pcre"
  depends_on "openssl"

  # 10.9 and clang fixes
  # Include reported upstream in:
  # https://code.google.com/archive/p/szl/issues/detail?id=28
  # Clang issue reported upstream in:
  # https://code.google.com/archive/p/szl/issues/detail?id=34
  patch :DATA

  def install
    ENV["OBJDUMP"] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"szl", "-V"
  end
end

__END__
diff --git a/src/utilities/random_base.cc b/src/utilities/random_base.cc
index 1d64521..e488321 100644
--- a/src/utilities/random_base.cc
+++ b/src/utilities/random_base.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <memory.h>
 #include <assert.h>
+#include <unistd.h>

 #include "public/porting.h"
 #include "public/logging.h"
diff --git a/src/engine/code.cc b/src/engine/code.cc
index d149f9a..75ab84b 100644
--- a/src/engine/code.cc
+++ b/src/engine/code.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <errno.h>
 #include <sys/mman.h>
+#include <unistd.h>

 #include "engine/globals.h"
 #include "public/logging.h"
diff --git a/src/engine/symboltable.cc b/src/engine/symboltable.cc
index 6d84592..71965f3 100644
--- a/src/engine/symboltable.cc
+++ b/src/engine/symboltable.cc
@@ -44,7 +44,7 @@ namespace sawzall {
 // ------------------------------------------------------------------------------
 // Implementation of SymbolTable

-Proc::Proc* SymbolTable::init_proc_ = NULL;
+Proc* SymbolTable::init_proc_ = NULL;

 List<TableType*>* SymbolTable::table_types_ = NULL;
 TableType* SymbolTable::collection_type_ = NULL;
