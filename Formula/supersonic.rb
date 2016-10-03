class Supersonic < Formula
  desc "C++ library providing a column oriented query engine"
  homepage "https://code.google.com/archive/p/supersonic/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/supersonic/supersonic-0.9.4.tar.gz"
  sha256 "1592dfd2dc73f0b97298e0d25e51528dc9a94e9e7f4ab525569f63db0442d769"
  revision 3

  bottle do
    cellar :any
    sha256 "91f211f1f97db835c2bfca0d57ef4395f2f0db1ac0bb29399fe4137d99489ae7" => :sierra
    sha256 "04ca7fc01824e99db96641ec2aad43b8f0e32d3366714997bb4b9eef8197b240" => :el_capitan
    sha256 "037e4b12ceb0973ce0e3132714e47f0d05d69aa74ad687cb811b76a452b62c7a" => :yosemite
  end

  if MacOS.version < :mavericks
    depends_on "protobuf" => "c++11"
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "protobuf"
    depends_on "boost@1.61"
  end

  depends_on "pkg-config" => :build
  depends_on "glog"
  depends_on "gflags"

  needs :cxx11

  def install
    ENV.cxx11

    # gflags no longer supply .pc files; supersonic's compile expects them.
    ENV["GFLAGS_CFLAGS"] = "-I#{Formula["gflags"].opt_include}"
    ENV["GFLAGS_LIBS"] = "-L#{Formula["gflags"].opt_lib} -lgflags"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-re2"
    system "make", "clean"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <supersonic/supersonic.h>
      using std::cout;
      using std::endl;
      using supersonic::BoundExpressionTree;
      using supersonic::Expression;
      using supersonic::Plus;
      using supersonic::AttributeAt;
      using supersonic::TupleSchema;
      using supersonic::Attribute;
      using supersonic::INT32;
      using supersonic::NOT_NULLABLE;
      using supersonic::FailureOrOwned;
      using supersonic::HeapBufferAllocator;
      using supersonic::View;
      using supersonic::EvaluationResult;
      using supersonic::SingleSourceProjector;

      BoundExpressionTree* PrepareBoundexpression_r() {
          scoped_ptr<const Expression> addition(Plus(AttributeAt(0), AttributeAt(1)));
          TupleSchema schema;
          schema.add_attribute(Attribute("a", INT32, NOT_NULLABLE));
          schema.add_attribute(Attribute("b", INT32, NOT_NULLABLE));
          FailureOrOwned<BoundExpressionTree> bound_addition =
              addition->Bind(schema, HeapBufferAllocator::Get(), 2048);

          if(bound_addition.is_success()) {
              return bound_addition.release();
          }

          return NULL;
      }

      const int32* AddColumns(int32* a, int32* b, size_t row_count, BoundExpressionTree* bound_tree) {
          TupleSchema schema;
          schema.add_attribute(Attribute("a", INT32, NOT_NULLABLE));
          schema.add_attribute(Attribute("b", INT32, NOT_NULLABLE));
          View input_view(schema);
          input_view.set_row_count(row_count);
          input_view.mutable_column(0)->Reset(a, NULL);
          input_view.mutable_column(1)->Reset(b, NULL);
          EvaluationResult result = bound_tree->Evaluate(input_view);
          if(result.is_success()) {
              cout << "Column Count : " << result.get().column_count() <<
                  " and Row Count" << result.get().row_count() << endl;
              return result.get().column(0).typed_data<INT32>();
          }

          return NULL;
      }

      int main(void) {
          int32 a[8] = {0, 1, 2, 3,  4, 5, 6,  7};
          int32 b[8] = {3, 4, 6, 8,  1, 2, 2,  9};

          scoped_ptr<BoundExpressionTree> expr(PrepareBoundexpression_r());
          const int32* result = AddColumns(a, b, 8, expr.get());

          if(result == NULL) {
              cout << "Failed to execute the addition operation!" << endl;
          }

          cout << "Results: ";
          for(int i = 0; i < 8; i++) {
              cout << result[i] << " ";
          }

          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-stdlib=libc++", "-lsupersonic", "-lglog", "-lprotobuf", "-lboost_system", "-o", "test"
    system "./test"
  end
end
