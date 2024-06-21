package com.gdut.crm.mapper;

import com.gdut.crm.pojo.Menu;
import com.gdut.crm.pojo.MenuSort;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface MenuMapper {
    String field = " id,name,parent_name,parent_id,menu_sort,menu_type,path,hidden,state,icon,perms,create_time,modify_time ";

    @Select("<script>" +
            "select id, name, parent_name, parent_id, menu_sort, menu_type, path, hidden, state, icon, perms, create_time, modify_time \n" +
            "        from t_menu \n" +
            "        where del_flag = '0' \n" +
            "        <if test=\"perms != null and perms != ''\">\n" +
            "            and perms = #{perms}\n" +
            "        </if>\n" +
            "        <if test=\"userId != null and userId != ''\">\n" +
            "            and id in (\n" +
            "                select menu_id from t_role_menu where role_id in (\n" +
            "                    select role_id from t_user_role where user_id = #{userId}\n" +
            "                )\n" +
            "            )\n" +
            "        </if>\n" +
            "        order by menu_sort" +
            "</script>"
    )
    @Results(id = "map", value = {
            @Result(column = "id", property = "id"),
            @Result(column = "name", property = "name"),
            @Result(column = "parent_name", property = "parentName"),
            @Result(column = "parent_id", property = "parentId"),
            @Result(column = "menu_sort", property = "menuSort"),
            @Result(column = "menu_type", property = "menuType"),
            @Result(column = "path", property = "path"),
            @Result(column = "hidden", property = "hidden"),
            @Result(column = "state", property = "state"),
            @Result(column = "icon", property = "icon"),
            @Result(column = "perms", property = "perms"),
            @Result(column = "create_time", property = "createTime"),
            @Result(column = "modify_time", property = "modifyTime"),
            @Result(column = "del_flag", property = "delFlag")
    })
    List<Menu> selectMenusByUserId(@Param("userId") String userId, @Param("perms") String perms);

    @Select("<script>" +
            "select id, name, parent_name, parent_id, menu_sort, menu_type, path, hidden, state, icon, perms, create_time, modify_time \n" +
            "        from t_menu \n" +
            "        where del_flag = '0' \n" +
            "<if test=\"userId != null and userId != ''\">\n" +
            "            and id in (\n" +
            "                select menu_id from t_role_menu where role_id in (\n" +
            "                    select role_id from t_user_role where user_id = #{userId}\n" +
            "                )\n" +
            "            )\n" +
            "        </if>\n" +

            "        order by menu_sort " +
            "<if test=\"pagingData\">" +
            "limit #{start},#{pageSize}" +
            "</if>" +
            "</script>"
    )
    @ResultMap("map")
    List<Menu> selectMenus(@Param("userId") String userId, @Param("pagingData") boolean pagingData, @Param("start") Integer start, @Param("pageSize") Integer pageSize);

    @Select("select count(id) from t_menu")
    long count();

    @Select("<script>" +
            "select id, name, parent_name, parent_id, menu_sort, menu_type, path, hidden, state, icon, perms, create_time, modify_time \n" +
            "        from t_menu \n" +
            "        where del_flag = '0' and perms = 'MANAGE' and parent_id = '0' \n" +
            "<if test=\"userId != null and userId != ''\">\n" +
            "            and id in (\n" +
            "                select menu_id from t_role_menu where role_id in (\n" +
            "                    select role_id from t_user_role where user_id = #{userId}\n" +
            "                )\n" +
            "            )\n" +
            "        </if>\n" +
            "        order by menu_sort" +
            "</script>"
    )
    @ResultMap("map")
    List<Menu> selectManageMenus(String userId);

    @Delete("delete from t_menu_sort where user_id = #{userId}")
    int deleteSort(String userId);

    @Insert("insert into t_menu_sort(user_id,menu_sort) " +
            "values(#{userId},#{menuSort})")
    int insertSort(@Param("userId")String userId,@Param("menuSort")String menuSort);

    @Select("select id,user_id,menu_sort from t_menu_sort where user_id = #{userId}")
    @Results(value = {
            @Result(property = "id",column = "id"),
            @Result(property = "menuSort",column = "menu_sort"),
            @Result(property = "userId",column = "user_id")
    })
    MenuSort selectMenuSort(String userId);
}
