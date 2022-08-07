const String getAllUsersQuery = """
query{
  getUsers{
    id
    name
    email
    job_title
  }
}

""";

const String getUserQuery = """
query (\$id: Int){
    getUserInfo(id: \$id) {
      id,
      name,
      job_title,
      email
    }
  }

""";
//  here id is in variable so we are passing id to filer user

const createUserMutation = """
mutation(\$name: String, \$email: String, \$job_title: String) {
    createUser (name: \$name, email: \$email, job_title: \$job_title)
  }
""";
//  here name,email, job_title, is called variable, , in simple terms - these are parameters , 

// this is mutation type of call , mutation is use to make change , like query is use to simply get data

const updateUserMutation = """
mutation(\$id: Int, \$name: String, \$email: String, \$job_title: String) {
    updateUserInfo (id: \$id, name: \$name, email: \$email, job_title: \$job_title)
  }
""";
//  here we are also passing id to update this user
const deleteUSerMutation = """
mutation(\$id: Int) {
    deleteUser(id: \$id)
  }

""";

//  it's simple mutation string  with id 
